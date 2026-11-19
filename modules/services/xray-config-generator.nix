{config, ...}: {
  config = {
    perSystem = {pkgs, ...}: {
      devShells.xray-config-generator = pkgs.mkShellNoCC {
        buildInputs = [(config.flake.lib.mkXrayConfigGenerator {pkgs = pkgs;})];
      };
    };

    flake = {
      lib = {
        mkXrayConfigGenerator = {
          pkgs,
          fallbackNginxPort ? 8080,
        }:
          pkgs.writers.writePython3Bin "xray-config-generator" {
            libraries = with pkgs.python3Packages; [
              pyyaml
              pydantic
            ];
            flakeIgnore = ["E111" "E501" "E721"];
          }
          /*
          python
          */
          ''
            import argparse
            import pathlib
            from typing import Any, List
            import json

            import yaml
            from pydantic import BaseModel


            def get_missed_args(args, required_args):
                missed_args = []
                for arg in required_args:
                    if getattr(args, arg, None) is None:
                        missed_args.append(arg)
                return missed_args


            class Client(BaseModel):
                id: str
                flow: str


            class Clients(BaseModel):
                tag: str
                clients: List[Client]


            class NextPeer(BaseModel):
                tag: str
                id: str


            class Inbound(BaseModel):
                tag: str
                listen: str | None = None
                port: int | None = None
                protocol: str
                settings: Any | None = None
                streamSettings: Any | None = None
                sniffing: Any | None = None


            class Outbound(BaseModel):
                tag: str
                sendThrough: str | None = None
                protocol: str
                settings: Any | None = None
                streamSettings: Any | None = None
                mux: Any | None = None
                targetStrategy: str | None = None


            class Config(BaseModel):
                env: Any | None = None
                log: Any | None = None
                api: Any | None = None
                dns: Any | None = None
                routing: Any | None = None
                inbounds: List[Inbound] = []
                outbounds: List[Outbound] = []
                stats: Any | None = None
                fakedns: Any | None = None
                metrics: Any | None = None
                observatory: Any | None = None
                burstObservatory: Any | None = None
                geodata: Any | None = None
                version: Any | None = None


            def apply_next_peer(outbounds: List[Outbound], next_peer: NextPeer):
                for outbound in outbounds:
                    if outbound.tag == next_peer.tag:
                        outbound.settings["id"] = next_peer.id
                        return
                raise RuntimeError(
                    f"Outbound with next peer tag {next_peer.tag} not found!")


            def apply_clients(
                inbounds: List[Inbound],
                clients: Clients,
                cert_file: pathlib.Path,
                key_file: pathlib.Path,
            ):
                for inbound in inbounds:
                    if inbound.tag == clients.tag:
                        inbound.settings["clients"] = clients.clients
                        if inbound.streamSettings["security"] != "tls":
                            raise RuntimeError(
                                "Expected tls security set in inbound streamSettings but it is not!"
                            )
                        if "tlsSettings" not in inbound.streamSettings:
                            inbound.streamSettings["tlsSettings"] = {}
                        inbound.streamSettings["tlsSettings"]["certificates"] = [{
                            "certificateFile": str(cert_file),
                            "keyFile": str(key_file),
                        }]
                        if inbound.settings["fallbacks"][0]["dest"] != ${toString fallbackNginxPort}:
                            raise RuntimeError(f"Inbound with tag {clients.tag} must have default fallback to ${toString fallbackNginxPort} port")
                        return
                raise RuntimeError(f"inbound with next peer tag {clients.tag} not found!")


            def gen_client(base_config: Config, next_peer: NextPeer):
                apply_next_peer(base_config.outbounds, next_peer)


            def gen_peer(
                base_config: Config,
                next_peer: NextPeer,
                clients: Clients,
                cert_file: pathlib.Path,
                key_file: pathlib.Path,
            ):
                apply_next_peer(base_config.outbounds, next_peer)
                apply_clients(base_config.inbounds, clients, cert_file, key_file)


            def gen_endpoint(
                base_config: Config,
                clients: Clients,
                cert_file: pathlib.Path,
                key_file: pathlib.Path,
            ):
                apply_clients(base_config.inbounds, clients, cert_file, key_file)


            def main():
                parser = argparse.ArgumentParser(
                    description="merge yaml configs(right merge)")
                parser.add_argument(
                    "mode", type=str
                )
                parser.add_argument(
                    "base_config",
                    type=pathlib.Path,
                )
                parser.add_argument(
                    "--clients_config",
                    type=pathlib.Path,
                )
                parser.add_argument(
                    "--cert_file",
                    type=pathlib.Path,
                )
                parser.add_argument(
                    "--key_file",
                    type=pathlib.Path
                )
                parser.add_argument(
                    "--next_peer_config",
                    type=pathlib.Path
                )

                args = parser.parse_args()
                mode = args.mode
                missed_args = []
                if mode == "client":
                    missed_args = get_missed_args(args, ["next_peer_config"])
                elif mode == "peer":
                    missed_args = get_missed_args(
                        args, ["clients_config", "cert_file", "key_file", "next_peer_config"]
                    )
                elif mode == "endpoint":
                    missed_args = get_missed_args(
                        args, ["clients_config", "cert_file", "key_file"])
                else:
                    raise RuntimeError(f"Undefined mode: {mode}")

                if missed_args != []:
                    raise RuntimeError(
                        f"Required arguments for mode {mode} are not set! Missed required args: {missed_args}"
                    )

                with open(args.base_config, "r") as file:
                    config = Config.model_validate(yaml.load(file, Loader=yaml.CLoader))

                next_peer_config = None
                if args.next_peer_config:
                    with open(args.next_peer_config, "r") as file:
                        next_peer_config = NextPeer.model_validate(
                            yaml.load(file, Loader=yaml.CLoader)
                        )
                clients_config = None
                if args.clients_config:
                    with open(args.clients_config, "r") as file:
                        clients_config = Clients.model_validate(
                            yaml.load(file, Loader=yaml.CLoader)
                        )

                if mode == "client":
                    if next_peer_config is None:
                        raise RuntimeError("next_peer_config is not passed!")
                    gen_client(config, next_peer_config)
                elif mode == "peer":
                    if next_peer_config is None:
                        raise RuntimeError("next_peer_config is not passed!")
                    if clients_config is None:
                        raise RuntimeError("clients_config is not passed!")
                    gen_peer(
                        config, next_peer_config, clients_config, args.cert_file, args.key_file
                    )
                else:
                    if clients_config is None:
                        raise RuntimeError("clients_config is not passed!")
                    gen_endpoint(config, clients_config, args.cert_file, args.key_file)

                print(json.dumps(config.model_dump(exclude_none=True)))

                return 0


            if __name__ == "__main__":
                exit(main())
          '';
      };
    };
  };
}
