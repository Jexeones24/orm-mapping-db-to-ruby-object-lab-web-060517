require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end


  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
      SQL

    DB[:conn].execute(sql, name).map do |row| new_from_db(row)
    end.first
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(grade)
      FROM students
      WHERE grade = 9
      SQL

    DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(x_num_of_students)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
      SQL

    DB[:conn].execute(sql, x_num_of_students)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT COUNT(grade)
      FROM students
      WHERE grade < 12
      SQL

    DB[:conn].execute(sql)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      SQL

      row = DB[:conn].execute(sql).shift
      first_student = Student.new
      first_student.id = row[0]
      first_student.name = row[1]
      first_student.grade = row[2]
      first_student
  end

  def self.all_students_in_grade_x(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      SQL

    DB[:conn].execute(sql, grade)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
