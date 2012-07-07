program dz5_pom;
type
	recKos = record
		ime: string[20];
		prezime: string[20];
		p,s,f,il: integer;
	end;

var dat: file of recKos;
	i: integer;
	c: char;
	kosarkas: recKos;
	nameDat: string[20];
begin
	
	writeln;
	write('ime datoteke: '); readln(nameDat);
		
	assign(dat, nameDat);
	rewrite(dat);

	i:=0;	
	repeat
		inc(i);
		writeln('---- kosarkas br.', i, ': ');
		write('ime: '); readln(kosarkas.ime);
		write('prezime: '); readln(kosarkas.prezime);		
		write('postignuti poeni: '); readln(kosarkas.p);
		write('skokovi: '); readln(kosarkas.s);
		write('faulovi: '); readln(kosarkas.f);
		write('izgubljene lopte: '); readln(kosarkas.il);
		write(dat, kosarkas);
		write('unos sledeceg kosarkasa [Y,n]? '); readln(c);
	until c='n';
	
	close(dat);
end.
