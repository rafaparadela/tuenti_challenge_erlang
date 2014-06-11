-module(c01).
-export([start/0]).

start() ->
	StudentsLine = readlines(),
	processStudentLine(StudentsLine,[]).
	
processStudentLine([], Students) ->
	Cases = [{"F","23","Forensic Science","1"},{"M","23","Chemical Engineering","3"},{"F","19","Microbiology","4"},{"M","26","Mechanical Engineering","5"},{"M","20","Architectural Engineering","4"},{"M","26","Biology","2"},{"M","20","Environmental Engineering","5"},{"M","21","Meteorology","1"},{"M","19","Psychology","5"},{"M","25","Mathematics","2"}],
	study_cases(Cases, Students, 1);

processStudentLine([StudentLine | Rest], Students) ->
	Student_string = string:tokens(StudentLine, ","),
	Student_tuple= list_to_tuple(Student_string),
	NewStudents = lists:append(Students, [Student_tuple]),
	processStudentLine(Rest, NewStudents).

study_cases([], Students, Counter) ->
	 ok;
	
study_cases([Case | RestCases], Students, Counter) ->
	InitialStatus = "NONE",
	study_case(Case, Students, Counter, InitialStatus),
	study_cases(RestCases, Students, Counter+1).
	
study_case({Sexo_case,Edad_case,Carrera_case,Curso_case}, [], Counter, StatusCase) ->
	io:format("Case #~w: ~s ~n", [Counter, StatusCase]);
	
study_case({Sexo_case,Edad_case,Carrera_case,Curso_case}, [{Nombre_student, Sexo_student, Edad_student, Carrera_student, Curso_student} | Rest_students], Counter, StatusCase) ->
	if 
		Carrera_case == Carrera_student, Sexo_case == Sexo_student, Edad_case == Edad_student, Curso_case == Curso_student  ->
			if 
				StatusCase == "NONE" ->
					NuevoStatus = Nombre_student;
				true ->
					NuevoStatus = StatusCase ++ ", " ++ Nombre_student
			end;
		true ->
			NuevoStatus = StatusCase
	end,
	
	study_case({Sexo_case,Edad_case,Carrera_case,Curso_case}, Rest_students, Counter, NuevoStatus).
	



% READ STUDENT FILE
readlines() ->
    {ok, Device} = file:open('students', [read]),
    try readdata(Device, [])
      	after file:close(Device)
    end.

readdata(Device, Accum) ->
	case io:get_line(Device, "") of
		eof  -> file:close(Device), lists:reverse(Accum);
	    Line -> 
			readdata(Device, [(Line--"\n")|Accum])
		% io:format("~s ~n", [Line])
	end.	
	

