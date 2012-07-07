program dz2;
const MAX_BR_EL = 100;
var
	br_el,i,p,n:integer;
	srednjav:real;
	niz: array [1..MAX_BR_EL] of integer;
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
		
		write('broj elemenata niza: '); readln(br_el);
	end;
	
	writeln('... exit!');
	
end.
