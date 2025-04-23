program ej3prac2FOD;
const
	valoralto = 'zzz';
type
	provincia = record
		nom:string;
		cantPA:integer;
		totalE:integer;
	end;
	provDet = record
		nom:string;
		cod:integer;
		cantA:integer;
		cantE:integer;
	end;
	maestro = file of provincia;
	detalle = file of provDet;
	procedure cargarMaestro(VAR mae:maestro; VAR cargaProv:text); //cargo los archivos desde un txt para apresurar la carga
	var
		nom:string; p:provincia;
	begin
		writeln('ingrese un nombre para el archivo maestro');
		readln(nom);
		assign(mae,nom);
		rewrite(mae);
		reset(cargaProv);
		while not eof(cargaProv) do begin
			with p do begin
				readln(cargaProv,cantPA,totalE,nom);
				write(mae,p);
			end;
		end;
		close(cargaProv);
		close(mae);
		writeln(' Archivo Maestro Cargado ');
	end;
	procedure cargarDet(VAR det:detalle; VAR cargaProvDet:text);    //cargo los archivos desde un txt para apresurar la carga
	var
		p:provDet;
	begin
		rewrite(det);
		reset(cargaProvDet);
		while not eof(cargaProvDet) do begin
			with p do begin
				readln(cargaProvDet,cantA,cantE,cod,nom);
				write(det,p);
			end;
		end;
		close(cargaProvDet);
		close(det);
		writeln(' Archivo Detalle Cargado ');
	end;
	procedure leer (VAR det:detalle; VAR dato:provDet);
	begin
		if not eof(det) then
			read(det,dato)
		else
			dato.nom := valoralto;
	end;
	procedure minimo (VAR det1,det2:detalle; VAR pd1,pd2,min:provDet);
	begin
		if(pd1.nom<=pd2.nom) then begin
			min:=pd1;
			leer(det1,pd1);
		end
		else
			begin
				min:=pd2;
				leer(det2,pd2);
			end;	
	end;
	procedure actualizarMaestro(VAR mae:maestro; VAR det1,det2:detalle);
	var
		p:provincia;
		min,pd1,pd2:provDet;
	begin
		reset(det1);
		reset(det2);
		reset(mae);
		leer(det1,pd1);
		leer(det2,pd2);
		minimo(det1,det2,pd1,pd2,min);
		while(min.nom<>valoralto) do begin
			read(mae,p);
			while(p.nom<>min.nom) do
				read(mae,p);
			while(p.nom = min.nom) do begin
				p.cantPA:= p.cantPA + min.cantA;
				p.totalE := p.totalE + min.cantE;
				minimo(det1,det2,pd1,pd2,min);
			end;
			seek(mae,filepos(mae)-1);
			write(mae,p);
		end;
	end;
	procedure impDet (VAR det:detalle);
	var
		pd:provDet;
	begin
		reset(det);
		while not eof(det) do begin
			read(det,pd);
			with pd do
				writeln('| Cod de localidad : ',cod,' Nombre de provincia : ',nom, ' Cantidad alfabezitados : ', cantA, ' Cantidad encuestados : ', cantE);
		end;
	end;
	procedure impMae (VAR mae:maestro);
	var
		p:provincia;
	begin
		reset(mae);
		while not eof(mae) do begin
			read(mae,p);
			with p do
				writeln(' nombre de provincia : ',nom,' Cantidad total personas alfabetizadas : ', cantPA,' Total de encuestados : ', totalE);
		end;
	end;
var
	det1,det2:detalle;
	mae:maestro;
	cargaProv:text;
	cargaProvDet1:text;
	cargaProvDet2:text;
begin
	assign(cargaProv,'cargaMaestro.txt');
	assign(cargaProvDet1,'cargaDetalle1.txt');
	assign(cargaProvDet2,'cargaDetalle2.txt');
	assign(det1,'archivodetalle1');
	assign(det2,'archivodetalle2');
	cargarMaestro(mae,cargaProv);
	cargarDet(det1,cargaProvDet1);
	cargarDet(det2,cargaProvDet2);
	impDet(det1);
	impDet(det2);
	impMae(mae);
	actualizarMaestro(mae,det1,det2);
	writeln(' //////////////////imprimo maestro actualizado////////////////////////////// ');
	impMae(mae);
end.
