program ej5prac1FOD;
type
	celular = record
		cod:integer;
		nom:string;
		desc:string;
		marca:string;
		precio:real;
		stockMin:integer;
		stockDisp:integer;
	end;
	celulares = file of celular;
	procedure crearArchivo (VAR cel:celulares);
	var
		c:celular; listaCel:text; nomF:string;
	begin
		writeln(' ingrese nombre del archivo binario');
		readln(nomF);
		assign(cel,nomF);
		assign(listaCel,'celulares.txt');
		rewrite(cel);
		reset(listaCel);
		while not eof(listaCel) do begin
			with c do begin
				readln(listaCel,cod,precio,marca);
				readln(listaCel,stockDisp,stockMin,desc);
				readln(listaCel,nom);
			end;
			write(cel,c);
		end;
		close(cel);
		close(listaCel);
	end;
	procedure opciones;
	begin
		writeln(' MENU DE OPCIONES ');
		writeln(' 1 - CREAR ARCHIVO BINARIO A PARTIR DE LISTA DE CELULARES EN TXT ');
		writeln(' 2 - IMPRIMIR ARCHIVO CREADO ');
		writeln(' 3 - LISTAR EN PANTALLA AQUELLOS CELULARES CON MENOOR STOCK AL STOCK MINIMO ');
		writeln(' 4 - LISTAR EN PANTALLA LOS CELULARES CON CUYA DESCRIPCION ');
		writeln(' 5 - AGREGAR CELULAR');
		writeln(' 0 - TERMINAR EL PROGRAMA ');
	end;
	procedure imprimirCelular (c:celular);
	begin
		writeln(' codigo : ', c.cod);
		writeln(' precio ',c.precio:0:2);
		writeln('marca : ', c.marca);
		writeln(' stock disponible : ',c.stockDisp);
		writeln(' stock minimo : ',c.stockMin);
		writeln(' descripcion : ',c.desc);
		writeln(' nombre : ',c.nom);
	end;
	procedure imprimirArchivo (VAR cel:celulares);
	var
		c:celular;
	begin	
		reset(cel);
		while not eof(cel) do begin
			read(cel,c);
			imprimirCelular(c);
		end;
		close(cel);	
	end;
	procedure buscarCelularDesc(VAR cel:celulares);
	var
		cadena:string;
		esta:boolean;
		c:celular;
	begin
		writeln(' ingrese descripcion para mostrar celulares con esta misma ');
		read(cadena);
		esta:=false;
		reset(cel);
		while not eof(cel) do begin
			read(cel,c);
			if(cadena = c.desc)then begin
				imprimirCelular(c);
				esta:=true;
			end;
		end;
		if(esta = false) then
			writeln(' no se encontro celulares con esta descripcion ');
		close(cel);
	end;
	procedure celularesMenorStock(VAR cel:celulares);
	var
		c:celular;
		esta:boolean;
	begin
		reset(cel);
		esta:=false;
		while not eof(cel) do begin
			read(cel,c);
			if(c.stockDisp<c.stockMin) then begin
				writeln(' CELULAR CON STOCK ACTUAL MENOR AL STOCK MINIMO ');
				imprimirCelular(c);
				esta:=true;
			end;
		end;
		if(esta = false) then
			writeln(' no se encontraron celulares con stock actual menor al stock minimo ');
		close(cel);
			
	end;
	procedure leerCelular(VAR c:celular);
	begin
		writeln(' ingrese codigo de celular, (-1 para no leer mas) : ');
		readln(c.cod);
		if(c.cod<>-1) then begin
			writeln(' ingrese precio : ');
			readln(c.precio);
			writeln('ingrese marca : ');
			readln(c.marca);
			writeln(' ingrese el stock disponible : ');
			readln(c.stockDisp);
			writeln(' ingrese el stock minimo : ');
			readln(c.stockMin);
			writeln(' ingrese la descripcion : ');
			readln(c.desc);
			writeln(' ingrese el nombre : ');
			readln(c.nom);
		end;
	end;
	procedure agregarCelular(VAR cel:celulares);
	var
		c:celular;
	begin
		reset(cel);
		seek(cel,filesize(cel));
		leerCelular(c);
		while(c.cod<>-1) do begin
			write(cel,c);
			leerCelular(c);
		end;
		close(cel);
	end;
	procedure menu (VAR cel:celulares);
	var
		op:integer;
	begin
		op:=-1;
		while(op<>0) do begin
			opciones;
			readln(op);
			case op of
				1: crearArchivo(cel);
				2: imprimirArchivo(cel);
				3: celularesMenorStock(cel);
				4: buscarCelularDesc(cel);
				5: agregarCelular(cel);
				
			end;
		end;
			
	end;
var
	cel:celulares;
begin
	menu(cel);
end.
