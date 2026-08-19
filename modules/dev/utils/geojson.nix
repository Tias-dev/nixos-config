{
  config.flake.modules.homeManager.geojson = {pkgs, ...}: let
    brunoToGeojson = (
      pkgs.writers.writePython3Bin
      "brunoToGeojson"
      {} ''
        import argparse
        import json

        parser = argparse.ArgumentParser(
            description="Convert bruno routing responses to geojson"
        )

        parser.add_argument(
            "-f", "--file", type=str, help="Path to bruno-cli JSON output",
            required=True)
        args = parser.parse_args()

        with open(args.file, "r") as file:
            data = json.load(file)

        results = data["results"]
        print(f"Found {len(results)} results")
        legs = []
        for result in results:
            filename = result["test"]["filename"]
            print(f"Name: {filename}")
            url = result["request"]["url"]
            print(f"Url: {url}")
            response = result["response"]
            if response["status"] != 200:
                print(
                    f"Response with error: {response["status"]}" +
                    f"{response["statusText"]}. skip..."
                )
                continue
            points = []
            lines = []
            if url.endswith("v1/route"):
                route = response["data"]["route"]
                legs.append(route)
            elif url.endswith("v2/robot/route"):
                for leg in response["data"]["legs"]:
                    legs.append(leg["path"])
            else:
                print("Undefinded url's endpoint. skip...")
                continue

            geojson = {"name": filename, "type": "FeatureCollection", "features": []}
            features = geojson["features"]

            point_id = 0
            for i, leg in enumerate(legs):
                if len(leg) == 0:
                    continue
                points = [leg[0], leg[-1]]
                for point in points:
                    features.append(
                        {
                            "type": "Feature",
                            "properties": {"id": point_id},
                            "geometry": {
                                "type": "Point",
                                "coordinates": [point["lon"], point["lat"]],
                            },
                        }
                    )
                    point_id += 1
                features.append(
                    {
                        "type": "Feature",
                        "properties": {"id": i},
                        "geometry": {
                            "type": "LineString",
                            "coordinates":
                            list(map(lambda x: [x["lon"], x["lat"]], leg)),
                        },
                    }
                )
            print(json.dumps(geojson, indent=2))
      ''
    );
    lonLatToGeojson = (
      pkgs.writers.writePython3Bin
      "lonLatToGeojson"
      {flakeIgnore = ["E111"];} ''
        import argparse
        import json
        import re
        import sys

        parser = argparse.ArgumentParser(
            description="Convert any lanes with 2 numbers(lon, lat) to geojson points"
        )
        parser.add_argument(
            "-r", "--reverse", action="store_true", help="Reverse lon, lat -> lat, lon"
        )

        args = parser.parse_args()

        lon, lat = 0, 1
        if args.reverse:
            lon, lat = lat, lon

        points = []
        for line in sys.stdin:
            coords = list(map(float, re.findall(r"\d+\.\d+|\d+", line)))
            if len(coords) == 2:
                points.append(coords)
            else:
                print(f"Skip line [{line[:-1]}]. Not found 2 coords", file=sys.stderr)
        geojson = {
            "type": "FeatureCollection",
            "features": list(
                map(
                    lambda x: {
                        "type": "Feature",
                        "geometry": {"type": "Point", "coordinates": [x[lon], x[lat]]},
                    },
                    points,
                )
            ),
        }
        print(json.dumps(geojson, indent=2))
      ''
    );
  in {
    home.packages = [brunoToGeojson lonLatToGeojson];
  };
}
