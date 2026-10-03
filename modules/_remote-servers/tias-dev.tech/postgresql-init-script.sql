SET
  TIME ZONE 'Europe/Moscow';

-- Tables
CREATE TABLE IF NOT EXISTS @schema@.students (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  group_number INTEGER NOT NULL,
  email VARCHAR(128) NOT NULL
);
GRANT all ON @schema@.students TO @role@;

CREATE TABLE IF NOT EXISTS @schema@.works (
  id SERIAL PRIMARY KEY,
  work_name VARCHAR(30) NOT NULL
);
GRANT all ON @schema@.works TO @role@;

CREATE TABLE IF NOT EXISTS @schema@.work_start (
  work_id INTEGER NOT NULL REFERENCES @schema@.works (id) ON DELETE CASCADE,
  group_number INTEGER NOT NULL,
  start_time TIMESTAMPTZ NOT NULL
);
GRANT all ON @schema@.work_start TO @role@;

CREATE TABLE IF NOT EXISTS @schema@.marks (
  student_id INTEGER NOT NULL REFERENCES @schema@.students (id) ON DELETE CASCADE,
  work_id INTEGER NOT NULL REFERENCES @schema@.works (id) ON DELETE CASCADE,
  mark INTEGER DEFAULT NULL,
  report_approved BOOLEAN DEFAULT FALSE
);
GRANT all ON @schema@.marks TO @role@;

-- views
CREATE OR REPLACE VIEW @schema@.work_start_view AS
SELECT
  t1.work_name,
  t2.group_number,
  t2.start_time
FROM
  @schema@.works AS t1
  INNER JOIN @schema@.work_start AS t2 ON t1.id = t2.work_id;
GRANT select ON @schema@.work_start_view TO @role@;

CREATE OR REPLACE VIEW @schema@.marks_view AS
SELECT
  t2.id AS student_number,
  t2.username,
  t2.group_number,
  t3.work_name,
  t1.mark,
  t1.report_approved
FROM
  @schema@.marks AS t1
  INNER JOIN @schema@.students AS t2 ON t1.student_id = t2.id
  INNER JOIN @schema@.works as t3 ON t1.work_id = t3.id;

GRANT select ON @schema@.marks_view TO @role@;

-- triggers
-- new student
CREATE OR REPLACE FUNCTION @schema@.insert_marks_on_student_added () RETURNS TRIGGER AS $$
DECLARE
	work RECORD;
BEGIN
	FOR work IN
		SELECT id FROM @schema@.works
	LOOP
		INSERT INTO @schema@.marks(student_id, work_id)
		VALUES (NEW.id, work.id);
	END LOOP;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- new work
CREATE OR REPLACE TRIGGER insert_marks_for_new_student
AFTER INSERT ON @schema@.students FOR EACH ROW
EXECUTE FUNCTION @schema@.insert_marks_on_student_added ();

CREATE OR REPLACE FUNCTION @schema@.insert_marks_on_work_added () RETURNS TRIGGER AS $$
DECLARE
	student RECORD;
BEGIN
	FOR student IN
		SELECT id FROM @schema@.students
	LOOP
		INSERT INTO @schema@.marks(student_id, work_id)
		VALUES (student.id, NEW.id);
	END LOOP;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER insert_marks_for_new_work
AFTER INSERT ON @schema@.works FOR EACH ROW
EXECUTE FUNCTION @schema@.insert_marks_on_work_added ();
