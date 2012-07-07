program dz5; { problem 0. }
type
	recKos = record
		ime: string[20];
		prezime: string[20];
		p,s,f,il: integer;
	end;
	
	element = ^recLista;
	recLista = record
		kosarkas: recKos;
		ik: real;
		sled: element;
	end;

var lista: element;	
	datName: string[20];

	
	function getDatName(var s:string[20]):boolean;
	begin
		write('naziv datoteke [enter=exit]: '); readln(s);
		getDatName := s <> '';
	end;
	

	procedure formListFromDat(var prvi:element; datName:string[20]);
	var dat: file of recKos;
		novi, posled: element;
	begin
		prvi := nil;
		posled := nil;
		assign(dat, datName);
		reset(dat);
		while not eof(dat) do begin
			new(novi);
			read(dat, novi^.kosarkas);
			novi^.sled := nil;
			if posled = nil
				then prvi:= novi
				else posled^.sled := novi;
			posled := novi;
		end;
		close(dat);
	end; { formListFromDat }


	procedure racunajIK(var prvi: element);
	var tek: element;
	begin
		tek := prvi;
		while tek <> nil do begin
			tek^.ik := 0.5*tek^.kosarkas.p + 0.8*tek^.kosarkas.s - 0.6*tek^.kosarkas.f - 2*tek^.kosarkas.il;
			tek := tek^.sled;
		end;
	end;


	procedure sortiraj(prvi: element);
	var tek1, tek2: element;
		tmpIK: real;
		tmpKosarkas: recKos; 
	begin
		tek1 := prvi;
		while tek1 <> nil do begin
			tek2 := tek1^.sled;
			while tek2 <> nil do begin
				if tek1^.ik < tek2^.ik then begin	
					tmpIK := tek1^.ik;
					tmpKosarkas := tek1^.kosarkas;
					
					tek1^.ik := tek2^.ik;
					tek1^.kosarkas := tek2^.kosarkas;
					
					tek2^.ik := tmpIK;
					tek2^.kosarkas := tmpKosarkas;
				end;
				tek2 := tek2^.sled;
			end;
			tek1 := tek1^.sled;
		end;
	end; { sortiraj }


	procedure brisi(var prvi: element);
	var stari: element;
	begin
		while prvi <> nil do begin
			stari := prvi;
			prvi := prvi^.sled;
			dispose(stari);
		end;
	end;


	procedure izbaciNegativne(var prvi: element);
	var tek, tmp: element;
	begin
		if prvi^.ik < 0 then brisi(prvi)
		else begin
			tek := prvi;
			while tek^.sled^.ik >= 0 do tek := tek^.sled;
			tmp := tek^.sled;
			tek^.sled := nil;
			brisi(tmp);
		end;
	end;


	procedure list2txt(tek: element);
	var dat: text;
		s: string[20];
		IKprosek: real;
		i: integer;
	begin
		write('naziv izlazne datoteke: '); readln(s);
		assign(dat, s);
		rewrite(dat);
		
		i:=0;
		IKprosek := 0;
		
		while tek<>nil do begin
			writeln(dat, tek^.kosarkas.prezime, ' ', tek^.kosarkas.ime, ' ', tek^.ik:0:2);
			
			inc(i);
			IKprosek := IKprosek + tek^.ik;

			tek := tek^.sled;
		end;
		
		if i<>0 then IKprosek := IKprosek / i;
		
		writeln(dat, '---------');
		writeln(dat, 'prosecni index korisnosti: ', IKprosek:0:2);
		
		close(dat);
		
		if s <> '' then writeln('datoteka ', s, ' uspesno kreirana');
	end; { list2txt }
	

	procedure obrada(var lista: element);
	begin
		racunajIK(lista);
		sortiraj(lista);
		izbaciNegativne(lista);
	end;
	
	
	procedure mod_ispis(tek: element);
	begin
		if tek <> nil then begin
			mod_ispis(tek^.sled);
			writeln(tek^.kosarkas.ime, ' ', tek^.kosarkas.prezime);
		end;
	end;
	

begin

	writeln;

	while getDatName(datName) do begin
		formListFromDat(lista, datName);
		obrada(lista);
		
		writeln('rekurzivni ispis:');
		mod_ispis(lista);
		writeln;
		
		list2txt(lista);
		brisi(lista);
		writeln;
	end;

	writeln('exit...');
end.
