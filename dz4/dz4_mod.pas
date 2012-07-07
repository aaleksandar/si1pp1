program dz4_mod;
type
	artikal = record
		sifraArtikla: integer;
		naziv: string[30];
		kolicina: real;
	end;
	
	filename = string[20];

var nameDatIN, nameDatOUT: filename; 
	
	
	function ucitajDatoteke(var nameDatIN,nameDatOUT: filename):boolean;
	begin
		write('ime ulazne datoteke: '); readln(nameDatIN);
		write('ime izlazne datoteke: '); readln(nameDatOUT);
		ucitajDatoteke := (nameDatIN <> '') and (nameDatOUT <> '');
	end;

	
	procedure writeOUT(var dat:text; var art:artikal);
	begin
		if art.naziv <> '' then begin
			write(dat, art.sifraArtikla, ', ');
			write(dat, art.naziv, ', ');
			writeln(dat, art.kolicina:0:2);
		end;
	end;
	

	function artFromStr(str: string[80]):artikal;
	begin
		val( copy(str,1,pos(',',str)-1), artFromStr.sifraArtikla );
		str := copy (str, pos(',', str)+2, length(str));
		artFromStr.naziv := copy (str, 1, pos(',', str)-1);
		artFromStr.naziv := lowercase(artFromStr.naziv);
		artFromStr.naziv[1] := upcase(artFromStr.naziv[1]);
		str := copy (str, pos(',', str)+2, length(str));		
		val(str, artFromStr.kolicina);
	end;

	
	procedure obrada(nameDatIN,nameDatOUT: filename);
	var datIN, datOUT: text;
		art, prevArt: artikal;
		tmpStr:string[80];
		linije: set of 1..50;
		lin, i: integer;
	begin
	
		write('koje linije oces da citas [1..50]: ');
		linije := [];
	
		read(lin);
		while (lin >= 1) and (lin <= 50) do begin
			linije := linije + [lin];
			read(lin);
		end;
		readln;
	
		assign(datIN, nameDatIN); reset(datIN);
		assign(datOUT, nameDatOUT);	rewrite (datOUT);
	
		i:=1;
		
		readln(datIN, tmpStr);
		if i in linije
			then prevArt := artFromStr(tmpStr)
			else prevArt.sifraArtikla := -1;
	
		while not eof(datIN) do begin
			inc(i);
			readln(datIN, tmpStr);
			
			if i in linije then begin
				art := artFromStr(tmpStr);
	
				if (art.sifraArtikla = prevArt.sifraArtikla) and (art.naziv = prevArt.naziv)
					then prevArt.kolicina := prevArt.kolicina + art.kolicina
					else begin
						writeOUT(datOUT, prevArt);
						prevArt := art;
					end;
			end;
		end;
		
		writeOUT(datOUT, prevArt);
	
		close (datIN);
		close (datOUT);
		
		writeln('uspesno napravljena datoteka ', nameDatOUT);
		writeln;
		writeln('ponovi unos (prazan string za izlaz): ');
	end;

	
begin

	while ucitajDatoteke(nameDatIN, nameDatOUT) do
		obrada(nameDatIN, nameDatOUT);
		
	writeln('exit...');
	
end.
