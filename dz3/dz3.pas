program dz3; { problem no.2 - top }

type
	figura = (kralj, kraljica, top, skakac, lovac, pesak, nema_figure);
	bojafigure = (bela, crna, nema_boje);
	mat_fig = array ['A'..'H',1..8] of figura;
	mat_boj = array ['A'..'H',1..8] of bojafigure;
	slovo = 'A'..'H';
	broj = 1..8;

var	tabla_fig: mat_fig;
	tabla_boj: mat_boj;
	poz_sl: slovo;
	poz_br: broj;
	unet_top: boolean;
	

	procedure poz_decode(var poz_sl:slovo; var poz_br:broj); { deli string pozicije na komponente }
	var unos_pozicije: string[2]; 
	begin
		readln(unos_pozicije);
		poz_sl := upcase(unos_pozicije[1]);
		val(unos_pozicije[2], poz_br);
	end;
	
	procedure ucitaj_figure(boja: bojafigure; var tabla_fig: mat_fig; var tabla_boj: mat_boj);
	var br_ucitavanja, i, br_fig: integer;
		poz_sl: slovo;
		poz_br: broj;
		ispravan_unos: boolean;
		brojac_figura: figura;
	begin
		repeat 
			readln(br_ucitavanja);
			ispravan_unos := (br_ucitavanja>=0) and (br_ucitavanja<=16);
			if not ispravan_unos then write('greska, pokusaj ponovo: ');
		until ispravan_unos;
		
		for i:=1 to br_ucitavanja do begin
			repeat
				writeln('-- figura ', i, ': ');
				write('unesi tip figure (po rednom broju): '); readln(br_fig);
				write('pozicija: '); poz_decode(poz_sl, poz_br);
				ispravan_unos := (br_fig>=0) and (br_fig<=5) and (poz_sl>='A') and (poz_sl<='H') and (poz_br>=1) and (poz_br<=8);
				if not ispravan_unos then writeln('pogresno uneti podaci, pokusaj ponovo...');
			until ispravan_unos;
			
			for brojac_figura := kralj to pesak do
				if br_fig = ord(brojac_figura) then tabla_fig[poz_sl,poz_br] := brojac_figura;
			
			tabla_boj[poz_sl,poz_br] := boja;
		end;

	end;

	
	procedure broj_belih_topova(var tabla_fig:mat_fig; var tabla_boj:mat_boj);
	var i_sl:slovo;
		i_br:broj;
	begin
		write('broj belih topova: ');
		for i_sl := 'A' to 'H' do 
			for i_br := 1 to 8 do
				if (tabla_fig[i_sl,i_br] = top) and (tabla_boj[i_sl,i_br] = bela) then write (i_sl, i_br, ' ');				
		writeln;
	end;


	procedure ucitavanje(var tabla_fig: mat_fig; var tabla_boj: mat_boj); { puni matricu default vrednostima i poziva procedure za dalje ucitavanje}
	var i_sl: slovo;
		i_br: broj;
	begin
		for i_sl := 'A' to 'H' do 
			for i_br := 1 to 8 do begin
				tabla_fig [i_sl,i_br] := nema_figure;
				tabla_boj [i_sl,i_br] := nema_boje;
			end;
		
		writeln('--------------------------------------------------------------');
		writeln('figure: 0-kralj, 1-kraljica, 2-top, 3-skakac, 4-lovac, 5-pesak');
		writeln;
		
		write('br. belih figura: '); ucitaj_figure(bela, tabla_fig, tabla_boj);
		write('br. crnih figura: '); ucitaj_figure(crna, tabla_fig, tabla_boj);
		
	end;
	
	
	procedure ispisi_kretanje_topa(top_poz_sl:slovo; top_poz_br:broj; var tabla_fig:mat_fig; var tabla_boj:mat_boj);
	var poz_sl_l, poz_sl_r, i_sl: slovo;
		poz_br_g, poz_br_d, i_br: broj;
		attack: bojafigure;
	begin

		poz_sl_l := 'A';
		for i_sl:='A' to pred(top_poz_sl) do
			if tabla_fig[i_sl, top_poz_br] <> nema_figure then poz_sl_l := succ(i_sl);
		
		poz_sl_r := 'H';
		for i_sl := 'H' downto succ(top_poz_sl) do
			if tabla_fig[i_sl, top_poz_br] <> nema_figure then poz_sl_r := pred(i_sl);
			
		poz_br_d := 1;
		for i_br := 1 to pred(top_poz_br) do
			if tabla_fig[top_poz_sl, i_br] <> nema_figure then poz_br_d := succ(i_br);
			
		poz_br_g := 8;
		for i_br := 8 downto succ(top_poz_br) do
			if tabla_fig[top_poz_sl, i_br] <> nema_figure then poz_br_g := pred(i_br);
		
		
		write('moguce kretanje topa: ');
		for i_sl := poz_sl_l to pred(top_poz_sl) do write (i_sl,top_poz_br,' ');
		for i_sl := succ(top_poz_sl) to poz_sl_r do write (i_sl,top_poz_br,' ');
		for i_br := poz_br_d to pred(top_poz_br) do write (top_poz_sl,i_br,' ');
		for i_br := succ(top_poz_br) to poz_br_g do write (top_poz_sl,i_br,' ');
		writeln;
		
		
		if tabla_boj[top_poz_sl,top_poz_br] = bela
			then attack := crna
			else attack := bela;

		write('pozicije figura koje mozemo da pojedemo: ');
		
		poz_sl_l := pred(poz_sl_l);
		if poz_sl_l >= 'A' then
			if tabla_boj[poz_sl_l,top_poz_br] = attack then write(poz_sl_l,top_poz_br, ' ');
		poz_sl_r := succ(poz_sl_r);
		if poz_sl_r <='H' then
			if tabla_boj[poz_sl_r,top_poz_br] = attack then write(poz_sl_r,top_poz_br, ' ');
		poz_br_d := pred(poz_br_d);
		if poz_br_d >=1 then
			if tabla_boj[top_poz_sl,poz_br_d] = attack then write(top_poz_sl,poz_br_d, ' ');
		poz_br_g := succ(poz_br_g);
		if poz_br_g <= 8 then
			if tabla_boj[top_poz_sl,poz_br_g] = attack then write(top_poz_sl,poz_br_g, ' ');		
		writeln();
	end;
	
begin
	ucitavanje(tabla_fig, tabla_boj);
	
	repeat
		write('::: pozicija topa kojeg zelis da pratis: '); poz_decode(poz_sl, poz_br);
		
		unet_top := (tabla_fig[poz_sl,poz_br] = top) and (poz_sl>='A') and (poz_sl<='H') and (poz_br>=1) and (poz_br<=8);
		
		if unet_top then ispisi_kretanje_topa(poz_sl, poz_br, tabla_fig, tabla_boj)
		else writeln('...cya!');
	until not unet_top;	

	broj_belih_topova(tabla_fig, tabla_boj);	

end.
