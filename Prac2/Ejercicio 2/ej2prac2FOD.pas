program ej2prac2FOD;
const
	valoralto = -1;
type
	producto = record
		cod:integer;
		nom:string;
		precio:real;
		stockAct:integer;
		stockMin:integer;
	end;
	venta = record
		codProd:integer;
		cantUni:integer;
	end;
	arcD = file of venta;
	arcM = file of producto;
	procedure cargarMaestro(VAR maestro:arcM; VAR cargaProd:text); //cargo los archivos desde un txt para apresurar la carga
	var
		nom:string; p:producto;
	begin
		writeln('ingrese un nombre para el archivo maestro');
		readln(nom);
		assign(maestro,nom);
		rewrite(maestro);
		reset(cargaProd);
		while not eof(cargaProd) do begin
			with p do begin
				readln(cargaProd,cod,precio,stockAct,stockMin,nom);
				write(maestro,p);
			end;
		end;
		writeln(' Archivo Maestro Cargado ');
		close(cargaProd);
		close(maestro);
	end;
	procedure cargarDet(VAR det:arcD; VAR cargaVent:text);    //cargo los archivos desde un txt para apresurar la carga
	var
		v:venta;
	begin
		assign(det,'archivoDiario');
		rewrite(det);
		reset(cargaVent);
		while not eof(cargaVent) do begin
			with v do begin
				readln(cargaVent,codProd,cantUni);
				write(det,v);
			end;
		end;
		writeln(' Archivo Det diario Cargado ');
		close(cargaVent);
		close(det);
	end;
	procedure leer (VAR det:arcD; VAR v:venta);
	begin
		if not eof(det) then
			read(det,v)
		else
			v.codProd := valoralto;
	end;
	procedure actualizarMaestro (VAR maestro:arcM; VAR det:arcD);
	var
		cantTot:integer; aux,v:venta; p:producto;
	begin
		reset(det);
		reset(maestro);
		leer(det,v);
		read(maestro,p);
		while(v.codProd<>valoralto) do begin
			cantTot:=0;
			aux:=v;
			while(v.codProd = aux.codProd) do begin
				cantTot:=cantTot + v.cantUni;
				leer(det,v);
			end;
			while (p.cod <> aux.codProd) do {se busca el producto del detalle en el maestro} //se tiene en cuenta por si hay productos que no vendieron entonces busca en el maesto hasta encontrar el codigo que se esta procesando
				read (maestro, p);
			p.stockAct:= p.stockAct-cantTot; {se modifica el stock del producto con la cantidad total vendida de ese producto}												
			seek(maestro, filepos(maestro)-1);{se reubica el puntero en el maestro}									
			write(maestro, p);{se actualiza el maestro}
			if (not(EOF(maestro))) then {se avanza en el maestro}
				read(maestro, p);
			end;
		close(det);
		close(maestro);
	end;
	procedure exportarTxt(VAR mae:arcM; VAR prodMin:text);
	var
		p:producto;
	begin
		assign(prodMin,'stock_minimo.txt');
		rewrite(prodMin);
		reset(mae);
		while not eof(mae) do begin
			read(mae,p);
			if(p.stockAct<p.stockMin) then
				with p do 
					writeln(prodMin,cod,precio,stockAct,stockMin,nom);
		end;
		close(prodMin);
		close(mae);
	end;
	procedure impDet (VAR det:arcD);
	var
		v:venta;
	begin
		reset(det);
		while not eof(det) do begin
			read(det,v);
			with v do
				writeln('| cod : ',codProd,' cantU : ',cantUni);
		end;
	end;
	procedure impMae (VAR mae:arcM);
	var
		p:producto;
	begin
		reset(mae);
		while not eof(mae) do begin
			read(mae,p);
			with p do
				writeln('| cod : ',cod,' nombre ',nom,' precio : ',precio:0:2,' stockAct : ',stockAct,' stockMin : ',stockMin);
		end;
	end;
	procedure opciones;
	begin
		writeln (' MENU DE OPCIONES ');
		writeln (' 1 : ACTUALIZAR ARCHIVO MAESTRO');
		writeln (' 2 CARGAR A TXT LOS PRODUCTOS CON STOCK ACTUAL MENOR AL STOCK MINIMO ');
		writeln (' 3 imprimir det ');
		writeln (' 4 imprimir mae ');
		writeln (' 9 TERMINAR');
	end;
	procedure menu(VAR det:arcD; VAR mae:arcM; VAR prodMin:text);
	var
		num:integer;
	begin
		num:=-1;
		while(num<>9) do begin
			opciones;
			readln(num);
			case num of
				1 : actualizarMaestro(mae,det);
				2 : exportarTxt(mae,prodMin);
				3 : impDet(det);
				4 : impMae(mae);
			end;
		end;
	end;
var
	det:arcD;
	maestro:arcM;
	cargaProd:text;
	cargaVent:text;
	ProdstockMin:text;
begin
	assign(cargaProd,'productos.txt');
	assign(cargaVent,'ventas.txt');
	cargarMaestro(maestro,cargaProd);
	cargarDet(det,cargaVent);
	menu(det,maestro,ProdstockMin);
end.
