function Student(first, last) {
  this.first = first;
  this.last = last;
  this.courses = [];
}

function Course(title, department){
  this.title = title;
  this.department = department;
  this.students = [];
}

Course.prototype.add_student = function(student) {
  this.students.push(student);
  student.courses.push(this);
}

Student.prototype.enroll = function(course) {
  course.add_student(this);
}

Student.prototype.courseload = function() {
  load = {}
  this.courses.forEach( function(course) {
    load[course.department] = load[course.department] + 1 || 1;
  })

  return load;
}

s1 = new Student('bob', 'zig');
c1 = new Course('history of magic', 'magic dept');
c2 = new Course("Friendship and Pareto Improvements", "Economics");
c3 = new Course("America is Awesome", "American Studies");
c4 = new Course("Stars and Stripes in Hydraulic Theory", "American Studies");

s1.enroll(c1);
s1.enroll(c2);
s1.enroll(c3);
s1.enroll(c4);


Object.keys(s1.courseload()).forEach ( function(dept) {
  console.log(dept,": " ,s1.courseload()[dept]);
})