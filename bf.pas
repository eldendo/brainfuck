(************************************
* a brainfuck interpreter in pascal *
* (c)2015 by ir. Marc Dendooven     *
* **********************************)

program brainfuck;
uses math;

const dataSize=30000;

var data: array[0..datasize] of char;
	p: 0..datasize;
	f: file of char;
	ch: char;
	
procedure bf_sequence;

	var start_sequence: Int64;

	procedure getCh;
	begin
		if eof(f) then halt else read(f,ch)
	end;

	procedure skip;
	var hooks: integer = 1;
	begin
		repeat 
			getCh;
			if ch = '[' then inc(hooks);
			if (ch = ']') and (hooks > 0) then dec(hooks)
		until (ch = ']') and (hooks = 0);
		getCh
	end;
	
	procedure debug;
	var i: integer;
	begin
		writeln;
		for i := max(p-5,0) to min(p+5,dataSize) do 
			begin
				if i=p then write('*');
				write(ord(data[i]),'|')
			end;	
		writeln
	end;

begin
	start_sequence := filepos(f);
	while true do
	begin
		getCh;
		case ch of
			'>': inc(p);
			'<': dec(p);
			'+': inc(data[p]);
			'-': dec(data[p]);
			'.': write(data[p]);
			',': read(data[p]);
			'[': if data[p] = #0 then skip else bf_sequence;
			']': if data[p] <> #0 then seek(f,start_sequence) else exit;	
			'#': debug	
		end
	end
end;

begin
	writeln('*************************************');
	writeln('* a brainfuck interpreter in pascal *');
	writeln('* (c)2015 by ir. Marc Dendooven     *');
	writeln('*************************************');
	for p := 0 to datasize do data[p] := #0;	
	p := 0;
	if paramStr(1)='' then begin writeln('sourcefile missing'); halt end;
	{$I-}
	assign (f,paramStr(1));
	reset(f,1);
	{$I+}
	if IOresult <> 0 then begin writeln('no such file'); halt end;
	
	bf_sequence
end.
