program dz2;
const MAX_BR_EL = 100;
var
	br_el,i,p,n:integer;
	srednjav:real;
	niz: array [1..MAX_BR_EL] of integer;
{mod}
	index: integer;		
{/mod}
begin
	write('broj elemenata niza: '); readln(br_el);

	while (br_el>0) and (br_el<=MAX_BR_EL) do begin	
		srednjav := 0;
		n:=0;
		repeat
			write('p: '); readln(p);
			if (p=0) then writeln('delis sa nulom?');
		until p<>0;
		
		for i:=1 to br_el do begin
			write('clan br.', i, ': '); readln(niz[i]);
			if (niz[i] mod p = 0) then begin
				srednjav := srednjav + (niz[i]*niz[i]*niz[i]);
				n := n+1;
			end;
		end;
	
		if n<>0 then srednjav := srednjav / n;
	
		writeln('srednja vrednost treceg stepena clanova deljivih sa ', p,	 ': ', srednjav:0:2);
		writeln('......');
		
		
{mod}
		write('redni broj indexa: '); readln(index);
		
		index := 1- (index mod 2);
		
		if (br_el mod 2 = 0) then br_el := br_el div 2
			else br_el := (br_el div 2) + index;
		
		for i:=1 to br_el do
			niz[i] := niz[i*2-index];
		
		write('elementi izbaceni... nova duzina: ', br_el, '... niz: ');
		
		for i:=1 to br_el do write(niz[i], ' ');
		
		writeln();
{/mod}
		
		write('broj elemenata niza: '); readln(br_el);
	end;
	
	writeln('... exit!');
	
end.
