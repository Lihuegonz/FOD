program ej1prac2FOD;
const
	valoralto = -1;
type
	empleado = record
		cod:integer;
		nom:string;
		monto:real;
	end;
	archivo = file of empleado;
	procedure crearArchivo(VAR arc:archivo; VAR carga:text);
	var
		nom:string;
		emp:empleado;
	begin
		writeln('ingrese nombre del archivo a crear');
		readln(nom);
		assign(arc,nom);
		reset(carga);
		rewrite(arc);
		while not eof(carga) do begin
			with emp do begin
				readln(carga,cod,monto,nom);
				write(arc,emp);
			end;
		end;
		writeln('Archivo binario creado');
		close(arc);
		close(carga);
	end;
	procedure leer (VAR arc:archivo; VAR dato:empleado); //corte de control para archivo
	begin
		if not eof(arc) then
			read(arc,dato)
		else
			dato.cod := valoralto;
	end;
	procedure actualizarMaestro (VAR arc:archivo; VAR maestro:archivo);
	var
		total:real;
		aux,emp,empmaster:empleado;
	begin
		assign(maestro,'archivoCompactado');
		reset(arc);
		rewrite(maestro);
		leer(arc,emp);
		while(emp.cod<>valoralto) do begin
			aux:=emp;
			total:=0;
			while(aux.cod = emp.cod) do begin
				total:=total + emp.monto;
				leer(arc,emp);
			end;
			empmaster:=aux;
			empmaster.monto:=total;
			write(maestro,empmaster);
		end;
		close(arc);
		close(maestro);
	end;
	procedure imprimirArchivoMaestro (VAR mae:archivo);
	var
		emp:empleado;
	begin
		reset(mae);
		while not eof(mae) do begin
			read(mae,emp);
			writeln('Codigo=', emp.cod, ' Nombre=', emp.nom, ' MontoTotal=', emp.monto:0:2);
		end;
		close(mae);
	end;
var
	arc,maestro:archivo;
	carga:text;
begin
	assign(carga,'empleados.txt');
	crearArchivo(arc,carga);
	actualizarMaestro(arc,maestro);
	imprimirArchivoMaestro(maestro);
end.
