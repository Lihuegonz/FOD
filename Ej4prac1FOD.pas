program ej4prac1FOD;
type
	empleado = record
		nro:integer;
		ape:string;
		nom:string;
		edad:integer;
		dni:integer;
	end;
	archivo_empleados = file of empleado;
	procedure imprimirEmp (e:empleado);
	begin
		write( ' | numero de empleado : ', e.nro);
		write( ' | nombre de empleado : ', e.nom);
		write( ' | apellido de empleado : ', e.ape);
		write( ' | edad de empleado : ', e.edad);
		write( ' | dni de empleado : ', e.dni);
	end;
	procedure cargarEmpleado(VAR e:empleado);
	begin
		writeln( ' ingrese apellido ' );
		readln(e.ape);
		if(e.ape<>'fin') then begin
			writeln( ' ingrese nombre ' );
			readln(e.nom);
			writeln( ' ingrese nro de empleado ' );
			readln(e.nro);
			writeln( ' ingrese edad ' );
			readln(e.edad);
			writeln( ' ingrese dni ' );
			readln(e.dni);
		end;
	end;
	procedure cargarArchivo(VAR arc_logico:archivo_empleados);
	var
		e:empleado;
	begin
		rewrite(arc_logico);
		cargarEmpleado(e);
		while(e.ape<>'fin') do begin
			write(arc_logico,e);
			cargarEmpleado(e);
		end;
		close(arc_logico);
	end;
	procedure buscarNomApe ( VAR arc_l:archivo_empleados; op:integer);
	var
		dato:string; e:empleado;
	begin
		if(op = 1)then begin
			writeln ( ' nombre a buscar del empleado ');
			readln(dato);
		end
		else 
			begin
				writeln ( ' apellido a buscar del empleado ');
				readln(dato);
			end;
		reset(arc_l);
		while not eof(arc_l) do begin
			read(arc_l,e);
			if(((op = 1) and (e.nom = dato)) or ((op = 2) and (e.ape = dato)))then
				imprimirEmp(e);
		end;;
		close(arc_l);
	end;
	procedure opciones;
	begin
		writeln ( ' Seleccione una opcion ');
		writeln ( ' 1 - para buscar empleado por nombre ');
		writeln ( ' 2 - para buscar empleado por apellido ');
		writeln ( ' 3 - para listar en pantalla a todos los empleados ');
		writeln ( ' 4 - para listar en pantalla empleados proximos a jubilarse ');
		writeln ( ' 5 - para agregar uno o mas empleados ');
		writeln ( ' 6 - modificar edad de algun empleado ');
		writeln ( ' 7 - exportar a txt ');
		writeln ( ' 0 - Terminar Programa ');
	end;
	procedure imprimir ( VAR arc_l:archivo_empleados);
	var
		e:empleado;
	begin;
		reset(arc_l);
		while not eof(arc_l) do begin
			read(arc_l,e);
			imprimirEmp(e);;
		end;
		close(arc_l);
	end;
	procedure listarJubilados ( VAR arc_l:archivo_empleados);
	var
		e:empleado;
	begin
		reset(arc_l);
		while not eof(arc_l) do begin
			read(arc_l,e);
			if(e.edad>75) then begin
				writeln ( ' empleado proximo a jubilarse : ');
				imprimirEmp(e);;
			end;
		end;
		close(arc_l);
	end;
	procedure agregarEmpleado(VAR emp:archivo_empleados);
	var
		e:empleado;
	begin
		reset(emp);
		seek(emp,filesize(emp)); //me posiciona en la ultima posicion del nodo despues del ultimo registro cargado
		cargarEmpleado(e);
		while(e.ape<>'fin') do begin
			write(emp,e);
			cargarEmpleado(e);
		end;
		close(emp);
	end;
	procedure modificarEdadEmpleado (VAR emp:archivo_empleados);
	var
		e:empleado; nro,edad:integer;
	begin
		writeln( ' ingrese nro de empleado para modificar su edad ' );
		readln(nro);
		writeln( ' ingrese la nueva edad ' );
		readln(edad);
		reset(emp);
		while not eof(emp) do begin
			read(emp,e);
			if(e.nro = nro) then begin
				e.edad:=edad;
				seek(emp,filesize(emp)-1);
				write(emp,e);
				writeln( ' Edad del empleado actualizada' );
			end;
		end;
		close(emp)
			
	end;
	procedure exportarTxt (VAR emp:archivo_empleados; VAR txt:text);
	var
		nomArch:string; e:empleado;
	begin
		writeln( ' nombre del archivo txt ' );
		readln(nomArch);
		assign(txt,nomArch);
		rewrite(txt);
		reset(emp);
		while not eof(emp) do begin
			read(emp,e);
			writeln(txt,e.nro,' ',e.ape, ' ', e.nom, ' ', e.edad, ' ', e.dni, ' ');
		end;
		close(txt);
		close(emp);
		
	end;
	procedure menu (VAR arc_logico:archivo_empleados; VAR txt:text);
	var
		op:integer;
	begin
		op:=-1;
		while(op<>0) do begin
			opciones;
			readln(op);
			case op of
				1: buscarNomApe(arc_logico,op);
				2: buscarNomApe(arc_logico,op);
				3: imprimir(arc_logico);
				4: listarJubilados(arc_logico);
				5: agregarEmpleado(arc_logico);
				6: modificarEdadEmpleado(arc_logico);
				7: exportarTxt(arc_logico,txt);
			end;
		end;
	end;
var
	arc_logico : archivo_empleados;
	arc_fisico : string;
	txt:text;
begin
	write ( ' ingrese nombre del archivo ' );
	readln(arc_fisico);
	assign(arc_logico,arc_fisico);
	cargarArchivo(arc_logico);
	menu(arc_logico,txt);
end.
