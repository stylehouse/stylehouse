#!/usr/bin/perl
use strict;
use warnings;
no warnings qw(uninitialized redefine);
use FindBin qw($Bin);
use lib "$Bin/othlia";
use lib "$Bin/slib";
use G;
sub dige { slm(12, Digest::SHA::sha256_hex( encode_utf8(shift) ) ) };
my ($A,$C,$G,$T);
my $ar = {};
!-d $_ && `mkdir -p $_` for qw'wormhole/digway G W';

use Mojolicious::Lite;
use MIME::Base64;
push @{app->static->paths}, '/home/s/styleshed/public';
app->secrets(["nothing"]);
# divert mojo log statements from our err channel
#app->log->path(($G->{c}->{ipd} || $G->{c}->{dir})."/mojo\.log")
#    if $G->{c}->{dir} || $G->{c}->{ipd};

our $listen = "http://localhost:1422";
if (-f 'listen') {
    $_ = `cat listen`; chomp $_;
    $listen = 'http://'.$_;
}
sub starts {
    1 && saybl "Starting     listens: $listen";
    app->start('daemon', '--listen' => "$listen");
}
sub JaBabz {
    my $C = shift;
    no warnings qw(uninitialized redefine);
    my $poing = qr/\w+(?:\.\w+)?/;
my $nlp = qr/[^\n]+/;
my $nls = qr/[ \t]*(?! *\/\/)/;
# < enj() should do this
my $jstring = sub { my ($s) = @_;
    $s = sjson([$s]);
    $s =~ s/^\[//;
    $s =~ s/\]$//;
    $s
};
my $hide = {};

# leaf 4:
my $twolt = '<<';
$C->{c}->{s} =~ s/^(\w+)(?: (-?\w+))?:(?: (%$nlp))?$/n $1 $2 \$s:$twolt'' $3/smg;
# blockquote til /^\s*$/g
# multi line, always \n$
# supposed to not babz anything in it...
# < stylehouse (the editor) must know this too
#     or it'll expand tabs to 4 spaces
$C->{c}->{s} =~ s{^(\s*)($nlp)<<(''|"")($nlp?)\n((?:\1$nlp\n)+)[ \t]*\n}{
# < allow empty lines with first line's indent
#   would be easy if we were iterating lines
    my $babin = $3 eq '""';
    my $ind = $1 || '';
    my $fore = $2;
    my $line = $ind.$fore."BlockQuote$4\n";
    my $was = $5;
    my ($reind) = $was =~ /^(\s+)/;
    $was =~ s/^$reind//sgm;
    if ($babin) {
        my $C = {c=>{s=>$was}};
        JaBabz($C);
        $was = $C->{c}->{s};
    }
    my $lines = [split /\n/, $was];
    $lines->[-1] eq '' && pop @$lines;
    # not always?
    #die "not nl last: aft $line: $lines->[-1] ".wdump 3,[$was,$lines];
    $lines = join "+\n", map {
        $ind.$jstring->("$_\n")
    } @$lines;
    $lines = $ind."var BlockQuote =\n$lines;";
    my $dig = dig($lines);
    $hide->{$dig} = $lines;
    "HIDING:$dig\n$line";
}smeg;

#$o = $G->{h}->($A,$C,$G,$T,"readLines",<<'');

# # comment to // comment
$C->{c}->{s} =~ s/^(\s*)#/$1\/\//gsm;
$C->{c}->{s} =~ s/( \{|}|;) #/$1 \/\//gsm;
# =pod (.+) =cut comment
$C->{c}->{s} =~ s/^(\s*)=\w+(.+?)^\s*=\w+\s*$/
    join "\n",map{"$1\/\/ $_"} split"\n",$2;
    /gesm;

# capital A is the more empiricle
$C->{c}->{s} =~ s/\bA&(\w+)\b/A\.c\.$1/g;
$C->{c}->{s} =~ s/\ba&(\w+)\b/A\.sc\.$1/g;
# and for $G->{h}->($A,$C,$G,$T,"somea","goof") -> $A->{some}->{sc}->{goof}
$C->{c}->{s} =~ s/\b(\w+)A&(\w+)\b/A\.$1\.c\.$2/g;
$C->{c}->{s} =~ s/\b(\w+)a&(\w+)\b/A\.$1\.sc\.$2/g;

# @Thing -> $A->{1}->{sc}->{Thing}
0 &&
$C->{c}->{s} =~ s/(?<!\w)\@(\w+)\b/1s\&$1/g;

# '$A->{4}->("tv") jo eig notch'
#  -> '$A->{4}->{y}->{tv} && $A->{4}->{y}->{tv}->{jo} && $A->{4}->{y}->{tv}->{jo}[0.1]' etc
# io but much simpler, single
# < could N many/gref with a sub
# < jsbab since so floody
# < going into $G->{h}->($A,$C,$G,$T,"things","uni/va/ve/la") etc
$C->{c}->{s} =~ s{\b($poing)&tv(( \$?\w+\b)+)}{
    my $thing = $1;
    my @path = split ' ', $2;
    my @expr = ("'$thing"."&tv @path'", $thing);
    for (@path) {
        my $cv = s/(\d+)$// ? $1 : 1;
        $cv *= 0.1 while $cv >= 1;
        my $t = s/^\$// ? '['.$_.']' : '.'.$_;
        push @expr, $thing.'.y', ($thing = $thing.'.y'.'.tv');
        push @expr, "$thing$t", ($thing = "$thing$t"."[$cv]");
    };
    join " && ", @expr;
}ges;



# $A->{3}->{sc}->{do} -> $A->{3}->{sc}->{do}
$C->{c}->{s} =~ s/\b(\d)(s|c)&(\w+)\b/"A[$1].".($2 eq 's' ? 'sc' : 'c').".$3"/smeg;
# make $G->{h}->($A,$C,$G,$T,"upA","thing") -> $A->{up}->{c}->{thing}
$C->{c}->{s} =~ s/\b(\w+)(a|A)&(\w+)\b/"A.$1.".($2 eq 'a' ? 'sc' : 'c').".$3"/smeg;
# $A->{1} -> A[1]
$C->{c}->{s} =~ s/\b([a-z]+)\.(\d)\b/$1.'['.$2.']'/gie;

# $v->{sc}->{do} -> $v->{sc}->{do}, etc
# < doing the above three paragraphs in this one:
# < $A->{up}->{c}->{s}->{sc}->{pi}...
$C->{c}->{s} =~ s[\b(\w+)(s|c|y)&(\w+)\b][
    my $arm = ($2 eq 's' ? 'sc' : $2).".$3";
    my $on = $1;
    my $wa = $on;
    my $s = 'A';
    if ($on =~ /^(up)+(C)?$/) { # $A->{up}->{sc}->{do} -> $A->{up}->{sc}->{do}
        # the other A aliases use $G->{h}->($A,$C,$G,$T,"upa","do")
        $s .= '.up' while $on =~ s/^up//;
        $s .= ".c\.s" if $on =~ s/^C//;

    }
    elsif ($on =~ /^\w\w+$/) { # $G->{h}->($A,$C,$G,$T,"oms","do") -> $om->{sc}->{do}
        # used to hang off A
        $s = $on;
    }
    else { # $z->{sc}->{do} -> $z->{sc}->{do}
        $s = $on;
    }
    $s.'.'.$arm
]smeg;

# capital C is the more universal (prefer $C->{sc}->{do})
$C->{c}->{s} =~ s/\bs&(\w+)\b/C\.sc\.$1/g;
$C->{c}->{s} =~ s/\bC&(\w+)\b/C\.sc\.$1/g;
$C->{c}->{s} =~ s/\bc&(\w+)\b/C\.c\.$1/g;

#c io
# recursive regex, but:
#   imbalanced brackets cause an infinite loop
# < something off the net
#   perldoc perlre "(??{ code })" onwards?
my $brackin;
$brackin = qr/\{[^\}\{]*$brackin?[^\}\{]*\}/;
my $varguessbab = sub { my ($t,$s,$varcod,$nocall) = @_;
    my $talk = $s;
    # talk is all the i is without the i
    my $cod = [];
    my $h = {path=>[],vars=>[],arks=>[]};
    my $defunc;$defunc = sub {
        $s =~ s/^\s+//s;
        if ($s =~ s/^((\w+:)*)\{/\{/s) {
            my $arkfor = $1; # not in $whole, can forget
            $h->{bail} = "not even" unless $s =~ /^$brackin/;
            $s =~ s/^($brackin)(:(\S+)|) ?//;
            my $whole = $1;
            my $withname = $2;
            my $name = $3;
            my $code = $whole;
            $code =~ s/\s+$//;
            $code =~ s/^\{|\}$//g;
            if ($code =~ /^(\w+)(?::(.+))?$/) {
                my $prerolled_function = $1;
                # which will peel/parse
                my $subtalk = $2;
                # < turn "la $inter " into "la ".$inter." "
                # < sjson string
                push @{$h->{vars}}, '"'.$subtalk.'"';
                my $now = "{$prerolled_function}";
                $talk =~ s/\Q$whole\E/$now/;
                # continue
                return $defunc->();
            }
            $code = [split ";", $code];
            # return last expression
            if ($code->[-1] !~ /return/) {
                my $expr = pop @$code;
                $expr =~ s/^\s+//;
                push @$code, " return $expr"
            }
            $code = join ";", @$code;
            $code = "&acgts"."{ $code }";
            push @{$h->{vars}}, $code;
            # its var is a function, its talk is anything else about it
            my $now = "{}";
            if ($name) {
                $now .= ":$name";
                push @{$h->{arks}}, $name;
            }
            $talk =~ s/\Q$whole$withname\E/$now/s
                || push @$cod, "no replacing: $whole";
            #push @$cod, "Would $name: $code\n"
            #    ."  onward: ".slim(20,$s)."\n";

            # and again
            $defunc->();
        }
    };
    my $after_first_pathy_thing;
    # since that redefines columns
    # assume @things, #things, $things, anything:things are for var/ar unpack
    $defunc->();
    my $firstpath = $h->{path};
    while ($s =~ s/^(\S+)\s*//) {
        my $island = $1;
        $firstpath = [@{$h->{path}}] if $island =~ /^[io]$/;
        my $path = [split '/', $island];
        for (@$path) {
            my $pa = {};
            # waving (and so we dont see :y)
            #   and this avoids latic:yon/... in paths...
            $pa->{arkfor} = $1 if @$path == 1 && s/^((\w+:)+)(\*)?y(\w|$)/${3}y$4/;
            # returning
            $pa->{ark} = $1 || 1 if s/:(\w*)$//;
            # greffing
            if (s/\{(\S+)\}?$//) {
                $pa->{gref} = $1;
                while ($pa->{gref} =~ /\$(\w[\w\[\]\.]*)/g) {
                    push @{$pa->{grefpara} ||= []},$1;
                    push @{$h->{vars}}, $1;
                }
                s/^/*/ if /^$/; # implies globbing
            }

            # parameters in
            $pa->{isdelete} = 1 if s/^-|-$//;
            $pa->{issark} = 1 if s/^@//;
            $pa->{isvar} = 1 if s/^#//;
            $pa->{isvar} = 2 if s/^\$//; 
            $pa->{issark} && $pa->{isvar} < 2 && delete $pa->{isvar};
            $pa->{t} = $_;
            my $varnamung;
            # the notion of C always split/linking domain names etc
            if ($pa->{t} =~ /^\w+[\[\.]\w/) {
                # A[1].$sc->{cee} named $cee
                # < could be pointing to anything
                #   into datatype (date/time/style?) aspects
                #   to/through/with functions
                #   at such rhythms, intro such dimension
                $varnamung = $pa->{t};
                my $name = $1 if $pa->{t} =~ /^\w[\w\[\]\.]+?(\w+)$/;
                !$name && die "Cant de-qualify name: $pa->{t}    in $talk";
                #1 && saybl "AHvo: $name ". substr($name,0,1) . " OPR " . substr($name,1,0);
                $name = "\$$name" unless
                    substr($name,0,1) eq "\$";
                $talk =~ s/\$?\Q$varnamung\E/$name/sg
                    || die "Cant find $pa->{t}    in $talk";
                $pa->{t} = $name;
                $pa->{isvar} = 1;
            }
            $pa->{isvar} && push @{$h->{vars}}, $varnamung || $pa->{t};
            $pa->{glob} = 1 if $pa->{t} =~ /^\*/;
            $pa->{word} = 1 unless $pa->{isvar} || $pa->{issark} || $pa->{glob};


            # not barewords or spacers :unless
            # but anything @plumbed
            $pa->{ark} = $pa->{t} if $pa->{ark} eq '1';
            !$after_first_pathy_thing
                && ($pa->{ark} || $pa->{issark}) &&
                    push @{$h->{arks}}, $pa->{ark} || $pa->{t};
            push @{$h->{path}}, $pa;
        }
        $after_first_pathy_thing = 1 if @$path > 1;
        $defunc->();
    }
    #c iocall
    return "Bailed: $h->{bail}" if $h->{bail};
    while (my ($t,$iv) = each %{$h }) { ref $iv eq 'HASH' || next;
    while (my ($i,$n) = each %{$iv }) {
        $n =~ /\W+/ && die "wobbyly $t varnameinterpretation: $n", $s;
    }}
    @{$h->{arks}} = uniq @{$h->{arks}};
    if (!@{$h->{arks}}) { # see $io->{realise}
        # accept $pa->{t} as a possible name
        for my $pa (@{$h->{path}}) {
            next if !$pa->{t};
            next if $pa->{t} =~ /\W/;
            push @{$h->{arks}}, $pa->{t}
        }
        # possibly just s
        @{$h->{arks}} = 's' if !@{$h->{arks}};
    }
    my $la = $firstpath->[-1];
    # the test: i $d/@la/@dio la:{} ... puts s as the {}
        #my $vork = '$d/@la/@dio';
        #$talk =~ m{\Q$vork\E}
        #    && saybl "Found it: ".wdump 5,[$h,$la];
    # maybe we should call it r if .../made:s {}
    # probably about right.. unplumbed {}$ could mean grep that stuff?
    #   except for row generation, which is how anyway?
    # < knowing better, realise() won't spit out doofs as s
    if (($la->{glob} || $la->{word}) && !$la->{ark} && !$la->{issark} && !grep {$_ eq 's'} @{$h->{arks}}) {
        @{$h->{arks}} = grep { $_ ne $la->{t} } @{$h->{arks}}; # remove word as nonark
        push @{$h->{arks}}, 's';
    }

    # S does var setting, or each io can set ay
    #   but not each $ay->{sc}.$arks
    my $sets = 'ay';

    push @$cod, "var $sets = " unless $nocall;
    $nocall->{sets} = $sets if $nocall;

    # put i/o in talk
    $talk = "$t $talk" if $nocall;
    # quote talk
    (my $vus = sjson([$talk])) =~ s/^\[|\]$//g;
    # call io (or dont)
    my $call = $nocall ? "" : "io\.$t(";
    push @$cod, "$call$vus,[";
    # bind params
    push @$cod, join ',', @{$h->{vars}} if @{$h->{vars}};

    push @$cod, ']'.($nocall ? "" : ");");
    # undef (becomes $cod) if $ar->{testing_io_vars}
    # else for hoisting up to the inside of the S {
    my $ya = '';
    # if not hoisting and returning an s column, set first one as ya
    $ya = " var ya = ay\.sc\.s && ay\.sc\.s[0];"
        if !$nocall && grep {$_ eq 's'} @{$h->{arks}};
    $varcod ||= $cod;
    push @$varcod, ' var '.$_.' = '.$sets.'.sc.'.$_.';' for uniq @{$h->{arks}};
    $cod = join '', @$cod, $ya;
    $ar->{ta} and push @{$ar->{ta}}, [$talk,$cod];
    return $cod
};
return $varguessbab if $ar->{ta};
$C->{c}->{s} =~ s{(^\s*|return )(i|o) ([\w\@\{\$\#]+[^\n]*[^\n;]+)$}{
    # unless testing, i/o doesn't set variables, only as S i/o
    my $varcod = $ar->{testing_io_vars} ? undef : [];
    "$1".$varguessbab->($2,$3,$varcod) }smeg;


#c each
        # each etc $data {    into:
        # while (my ($e,$tv) = each %$data) {
        # while (my ($t,$c) = each %$tv) {
        #   so the value tv is for t-ing into
        # DIY closing brackets
        # avoids eaching nonref after first
        # could replace with $G->{h}->($A,$C,$G,$T,"chew-ish") call if more spec
        # and know indents to close
        my $doi = sub {
            my ($ind,$in,$from) = @_;
            my @in = split ',', $in;
            @in = split '', $in[0] if @in == 1;
            my @open;
            while (@in) {
                my $k = shift(@in);
                my $v = shift(@in);
                unshift @in, $v if @in;
                $v = $v.'v' if @in;

                my $s = "for (var $k in $from) {";
                $s .= "\n    var $v = $from\[$k];";
                $s .= "\n    if(typeof $v != 'object') { continue }"
                    if @in;

                $from = $v;
                push @open, $s;
            }
            @open = map { $ind.$_ } @open;
            join "\n", @open;
        };
        $C->{c}->{s} =~ s/^(\s*)each (\w+(,\w+)*) (\S+) \{(\s*)$/
            $doi->($1,$2,$4);
        /smeg;


#
#c other
# (~hifnotc)?~com message: list, of, interestings
# < colouring or otherwise classifying by the source of the way
#   eg everything from 4* looks kind of blue, etc
#   more colour will jump in on top as aspects unfold, yadda

my $lnlp = qr/[^\n;]+/;
$C->{c}->{s} =~ s{(; |^|\{|and |return |= ) *~(?:(\w+)~)?(\$?>?[\w]+(?:$lnlp?:)?)(?: ($lnlp)?)?(;|$)}{
    my $ope = $1;
    my$c=$2||'c';
    my$s=$3;
    my$e=$4;
    $s=~s/:$//;
    $s = "'$s'" unless $s =~ s/^\$//;
    $ope."G\&$c:$s,[$e];"
}segm;

# chuck error: throw "Something", C 
#   throws new Error("Something"), its .tc=[C]
#     also handles concatenated bits for "Something":
my $varbits = qr/[\w\[\]\.]+/;
my $concatbit = qr/\+(?:[\w\[\]\.]+|"[^\n"]+")/;
$C->{c}->{s} =~ s{(^\s*(?!#)$nlp?)throw ("[^\n"]+?"$concatbit*)(, ?$nlp)?;?\s*$}{
    my $ope = $1;
    my $msg = $2;
    my $tc = $3;
    $msg =~ s/: ?"$/"/;
    my $guts = "new Error($msg)";
    if ($tc =~ s/^, ?//) {
        $tc =~ s/;$//;
        $guts = "{var er = $guts; er\.tc = [$tc]; throw er}";
        # "
    }
    else {
        $guts = "throw $guts;";
    }
    $ope.$guts
}segm;

# rechuck error: throw e, "inn"
#   pushes $e->{catches} $e->{stack} to $e->{stacks}[],
#     chrome < 2012 restacks when rethrowing
#   
$C->{c}->{s} =~ s{(^\s*(?!#)$nlp?)throw ($varbits)(, ?$nlp)?;?\s*$}{
    my $ope = $1;
    my $var = $2;
    my $tc = $3;
    my $guts = "($var\.catches = $var\.catches || [])";
    $tc = $tc =~ s/^, ?// ? ",tc:[$tc]" : "";
    $guts .= ".push({stack:$var\.stack$tc}); throw $var;"; # "
    $ope.$guts
}smeg;

#c n groundula, keywords, subs

# n thing -jod_33 s:var hue:'490deg'
#   c/sc get wrapped with {}
# or:
# n thing -jod_33 s:string %hue:490deg,note:$note+btw
#   and c/sc become $G->{h}->($A,$C,$G,$T,"peel") bits, $note+ becomes "+note+"
#   and c $s:object,$up:ob will make json (wrapped with {})
#   greediness of c/sc regarding % needs tuning
#     be nice to have spaces in c, editor could easily step over all this
# < C like this, but fits after { or =
# < n:r yabbada to $r = $G->{h}->($A,$C,$G,$T,"n",['yabbada','W'])
#   viz. this Babz decides when [t] means cW:t
#   and sets a variable to the C created
# also u:thing so that $thing becomes that object in the mind

my $blankycsc = '"",{},{}';
$C->{c}->{s} =~ s{(^\s*|return )(n|u|m|e) (\$)?("[^\n"]+"|\w+\S*)(?: (\$)?([-\w]*))?(?: ([^\n]*?))?(?: (%)?([^\n]*?))?$}{
    my $ope = $1;
    my $mode = $2;
    my $tvar = $3;
    my $t = $4;
    my $yvar = $5;
    my $y = $6;
    my $c = $7;
    my $scvar = $8;
    my $sc = $9;
    $t = '"'.$t.'"' if !$tvar;
    $y = '"'.$y.'"' if !$yvar;
    $scvar ||= 1;
    if ($scvar) {
        for ($c, $sc) {
            !$_ and s/^/{}/ && next;
            if ($_ eq $c && /^\$\w+:\w+/) {
                s/\$(\w+):(\w+)( )?/"$1:$2".(defined $3 ? ",":"")/seg;
                s/^/{/sg;
                s/$/}/sg;
                next;
            }
            s/\$([^\s\+]+)(\+|$)/"+$1+"/sg;
            s/^|$/"/sg;
            s/^(.*)$/"G\&"."peel,".$1." ";/smeg
        }
    }
    else {
        $c = "{$c}";
        $sc = "{$sc}";
    }
    my $guts = "G&".$mode.":";
    $guts .= "M," if $mode eq 'm';
    my $arg = "[$t,$y,$c";
    $arg .= ",$sc" if $sc;
    $arg .= "]";
    $arg = "$t" if
        $arg =~ s/,\Q$blankycsc\E]$/]/ && $tvar;
    $guts .= $arg;
    $ope.$guts.';'
}smeg;
#return

$C->{c}->{s} =~ s/^(\s*)elsif ?\(/${1}else if (/sgm;

# true or assign
# < match until closing bracket, see $brackin
$C->{c}->{s} =~ s/(\w\S*) \|\|\=(?: ($nlp)(;)?|\s*)$/$1 = $1 || $2$3/gm;

# left-hand if
$C->{c}->{s} =~ s/^($nls)([^\n]+?) and ($nlp)(;)?$/$1if ($2) {
$1    $3
$1}/gm for 1..3;

# sub { my ($raw,$args) = @_; -> function(raw,args){
# sub { my ($A,$C,$G,$T,$sec,$lamp,$socket) = @_; -> function(A,C,G,T,s,e,c,lamp,socket){
# < (arfgunc) a way to write its args on it without having to read via toString parse
$C->{c}->{s} =~ s/(\W|^)&(acgt)?(\w+)?((?:,\w+)+?)?(,)?\{/;
    my @args;
    my ($not,$acgt,$wordy,$commad,$wholimp) = ($1,$2,$3,$4,$5);
    if (!$acgt && $wordy && ($commad || $wholimp)) {
        # all,of,it is whole names, add comma to end if one \w+: &isparam,{
        @args = split ',', $wordy.$commad
    }
    else {
        # acgt on the front or no commas
        # means single letters until after commas
        @args = (
            split('', ($acgt && 'ACGT').$wordy),
            split(',', $commad),
        );
    }
    "${not}function(".join(',',map{$_}grep{$_}@args)."){"
/gem;

# $thing -> var thing
#  doesn't see '$get # vardescript', see # -> //
$C->{c}->{s} =~ s/^($nls)\$(\w+)(;|\s*=|\s*\/\/|$)/
    $1."var $2".($3||';')/smeg;

# GONER thing$ -> var thing (would perl alright tho...)
# still in Hut
$C->{c}->{s} =~ s/^($nls)(\w+)\$(?:;)?\s*(=|$)/
    $1."var $2".($3 eq '=' ? ' =' : ';')/smeg;


#c S domagic, G&
# see 25 Domes
my $wsnotnl = qr/[ \t]/;
my $anS = qr/^$wsnotnl*S($wsnotnl*| \w[^\n]*)$/m;
my $GandS = "G"."&"."S";
if ($C->{c}->{s} =~ $anS) {
    my @l = split /\n/, $C->{c}->{s};
    my $firstS = 1;
    @l = map {
        if (/$anS/) {
            my $args = $1;
            $args =~ s/^\s+|\s+$//g;
            # $G->{h}->($A,$C,$G,$T,"S",s/num,t/nam,talk/json(d),params)
            my $num = $1 if $args =~ s/^(\d+(?:\.\d+)?)\s*//;
            my $nam; # maybe 'S 3 (title): i/o ....
            # so then: } var sets; while(sets = $G->{h}->($A,$C,$G,$T,"S",3,'title','i/o ...',[params]) { var one = $sets->{sc}->{one}); ...
            my $sets; # name of $G->{h}->($A,$C,$G,$T,"S") return ^
            my $talkpara; # 'i/o ...',[params]
            my $setting = []; # the (var one = $sets->{sc}->{one};)+
            # talk,params pass through S, which iterates and sets vars inside
            $args =~ s{^(?:(.*?):? )?(i|o) ([\w\@\{\$\#]+[^\n]*[^\n;]+)$}{
                $nam = $1 if $1;
                my $nocall = {};
                $talkpara = $varguessbab->($2,$3,$setting,$nocall);
                $sets = $nocall->{sets};
                ''
            }smeg;

            # io-light, assume one eg $N may be returned from the call
            # < projected to expand... unless io is the place that also sees
            #   up the A train to where N and M etc live.
            #   coming from or going to Osc
            if ($args) {
                # title contains '$N' to while (N = ...)
                # title loses '$'
                if ($args =~ s/\$([^\s\+]+)(\+|$)/$1/sg) {
                    $1 && $sets && die "have dollarey $1 in args, also io return sets $sets";
                    $sets = $1;
                }
            }
            $nam && $args && die "io set nam='$nam', also args: $args";
            $nam = $args if $args;
            $nam = $jstring->($nam) if $nam;
            $num ||= "''" unless $num eq '0';
            $nam ||= "''";
            $args = join',',grep{length}$num,$nam,$talkpara;

            my $call = join':',grep{length}$GandS,$args;
            # conjoins while blocks
            my $con = $firstS ? "" : "} ";
            $firstS = 0;
            if ($sets) {
                $con .= "var $sets; ";
                $call = "$sets = $call";
            }
            $con .= "while (".$call.") {";
            if (@$setting) {

                #$setting = join ';', @$setting;
                #$setting =~ s/;;/;/sg;
                $con .=  join '',@$setting;
            }
            $con
        }
        else {
            $_
        }
    } @l;
    push @l, '}';
    $C->{c}->{s} = join "\n",@l;
}
# $G->{h}->($A,$C,$G,$T,"thing",args,"with space");     $e v
$C->{c}->{s} =~ s/($poing)\&(\$)?($poing)(?::([^\n;]+))(|\) ?\{ var.+$|\s*$|\s*$|;)/
    my ($on,$var,$p,$e,$t) = ($1,$2,$3,$4,$5);
    $t = "$1$t" if $e =~ s{(\) ?\{(?: var.+|))$}{};
    $e = ",$e" if length $e;
    ($on,my$in) = ("G\.h",'A,C,G,T,')
        if $on eq 'G';
    $p = "\"$p\"" unless $var;
    my $s = $on."($in$p$e)$t";
    $s = '$'.$s if $on !~ m{\.};
    $s
/smge;

# $G->{h}->($A,$C,$G,$T,"thing",args) && without space
$C->{c}->{s} =~ s/(G|$poing$poing)\&(\$)?($poing)(,[^\s;]+)?(;)?/
    my $t = $2 ? "$3" : "'$3'";
    my $h = $1 eq 'G' ? ".h(A,C,G,T,$t" : "\[$t\](A,C,G,T";
    $1.$h."$4)$5"
/smgei;
# $G->{h}->($A,$C,$G,$T,"g","be",'jit') requires args...
$C->{c}->{s} =~ s/($poing)\&(\$)?($poing)(,[^\s;]+)(;)?/
    my $t = $2 ? "$3" : "'$3'";
    my $h = $1 eq 'G' ? ".h(A,C,G,T,$t" : "\[$t\](A,C,G,T";
    $1.$h."$4)$5"
/smge;

if(1){
    # delete returns the deleted
    #  a block somehow?
    # delete $c->{per}   -> $se = $c->{per}; delete $c->{per}
    $C->{c}->{s} =~ s/ = delete ($poing[^\s;)]*)([\s;\)]*)/ = $1; delete $1$2/gsm;
}

# unhide blockquotation
%$hide && $C->{c}->{s} =~ s/HIDING:([0-9a-f]+)/$hide->{$1} || die "Cant find $1"/seg;

}
get '/' => sub { my ($c) = @_;
    $c->reply->static("two\.html");
};

#c /peek/ - pull it into stylehouse
any '/peek/*t' => sub { my ($c) = @_;
    my $resp = sub { my ($s) = @_; $c->render(text=>sjson($s)) };
    # look at:
    my $t = $c->param('t');
    # for a size or range:
    my $line = $c->param('line') || 0;
    # for directory, text,
    my $type = 'f';
    $t += '/*' if -d $t;
    $type = 'd' if $t =~ /\*/;
    
    my ($f) = my @l = glob $t;
    
    # weird corners:
    #  supplying ?-ambiguated $t matching many
    $type = 'd' if @l > 1 || -d $f;
    my $re = {type=>$type};
    return $resp->({sc=>{%$re,lines=>[@l],
        dige=>dige(join "\n",@l)}}) if $type eq 'd';
    # < symlinks
    return $resp->({er=>'not found'}) if !-f $f;
    
    my $size = $re->{sizekb} = 0.001 * (-s $f);
    return $resp->({er=>'too big: '.$size.'kb'}) if $size > 420;
    # < image or video...
    return $resp->({er=>'not text'}) unless -T $f;
    my $string = decode_utf8(read_file($f));
    @l = split "\n", $string;
    $re->{length} = 0+@l;
    
    # how to chop that up
    if ($line =~ s/<(\d+)$//) {
        # only shallow indents, dige between
        my $indentlt = $1;
        # always has a leading something
        my @between = [];
        @l = grep {
            if (!/\S+/ || /^ {$indentlt}/) {
                push @{$between[-1] ||= []}, $_;
                0
            }
            else {
                push @between, [];
                1
            }
        } @l;
        1 && sayre "indgrep $indentlt ".@l." < ".$re->{length};
        @between = map { !@$_ ? '' : @$_."x".dige(join("\n",@$_)) } @between;
        $re->{dige} = dige(join "\n",
            $between[0], map{ $l[$_], $between[$_+1]||'' } 0..@l-1
        );
        $re->{between} = \@between;
    }
    else {
        $line ||= 0;
        my $toline = $2 if $line =~ s/^(\d+)-(\d+)$/$1/;
        $toline ||= $line + 100;
        $re->{line} = $line;
        $toline = @l-1 if $toline > @l-1;
        @l = @l[$line..$toline];
        $re->{toline} = $line + @l;
        $re->{dige} = dige(join "\n",@l);
    }
    
    return $resp->({sc=>{%$re,lines=>[@l]}})
};

#c /digwaypoll/ notifier, see 281 Sevo
# < check on connect
my $poll = {tx=>[],ways=>{}};
$poll->{wayt} = {}; # pi/name -> pi-name
$poll->{wayd} = {}; # pi-name -> $C->{sc}->{dige}
get '/digwtf' => sub { my ($c) = @_;
    $c->render(text => wdump($poll->{wayd}));
};
$poll->{doing} = sub { my ($o) = @_;
    return if $o && $poll->{one} && $o ne $poll->{one};
    my $tw = {};
    while (my ($p,$i) = each %{$poll->{ways} }) {
        my $t = $p;
        $t = $poll->{wayt}->{"$p"} ||= do { $t =~ s/\W/-/sg; $t };
        my $digway = "wormhole/digway/$t";
        my $dig = readlink $digway;
        #1 && sayre "no $digway" if !$dig;
        next if !$dig;
        my $was = $poll->{wayd}->{"$t"};
        next if $was && $dig eq $was;
        $poll->{wayd}->{"$t"} = $dig;
        $tw->{$p} = $dig;
    }
    
    if (keys %$tw) {
        # send many d=0 Lines as one message,
        # so receiver can react immediately
        for my $tx (@{$poll->{tx}}) {
            my $s = join"", map{ $_ ."\n" }
                map{ $_.'%dige:'.$tw->{$_} }
                grep { !$tx->{ways}->{$_}
                    || $tx->{ways}->{$_} ne $tw->{$_}
                } keys %$tw;
            $tx->send($s);
            1 && saygr "digwaypoll: $s"
        }
    }
    
    Mojo::IOLoop->timer(0.3,sub { $poll->{doing}($poll->{one} = rand()) });
};
websocket '/digwaypoll' => sub { my ($s) = @_;
    my $tx = $s->tx;
    $poll->{doing}();
    1 && sayyl "Got digwaypolling";
    
    # complete picture (t/dige) at new listeners
    $poll->{wayd} = {};
    push @{$poll->{tx}}, $tx;
    
    my $addr = $tx->remote_address;
    Mojo::IOLoop->stream($tx->connection)->timeout(300000);
    $tx->max_websocket_size(512000);
    
    $s->on(message => sub { my ($M,$m) = @_; #}
        die "Not wordy: $m" unless $m =~ /^([\w\-\/]+)(%\w+.*)?$/;
        $tx->{ways}->{"$1"} ++ || $poll->{ways}->{"$1"} ++
    });
    
    $s->on(finish => sub { my ($M,$code,$reason) = @_;
        @{$poll->{tx}} = grep { $_ ne $tx } @{$poll->{tx}};
        while (my ($t,$i) = each %{$tx->{ways} }) {
            -- $poll->{ways}->{"$t"} && next;
            delete $poll->{ways}->{"$t"};
            $t = delete $poll->{wayt}->{"$t"};
            delete $poll->{wayd}->{"$t"};
        }
        1 && sayre "digwaypoll Gone: $addr $code $reason";
    });
};

#c /W/
any '/W/*W' => sub { my ($c) = @_;
    my $t = $c->param('W');
    my $s = $c->param('s');
    my $patch = $c->param('patch') && die "know patch";
    my $cache = $G->{Wache} ||= {};
    
    # read t, write if s
    # all there
    $t = "W/$t";
    # char safety
    $t =~ /([^\w\/-]+)/ && return
        $c->render(text=>sjson(
            {er=>"illegal t[".pos()."] char: $1 in '$t'"}
        ));
    # and you can't use the name 1 etc
    $t =~ s/\/(\d)$//;
    my $species = $1 || '1';
    my $f = "$t/$species";
    
    # returns json:
    my $re = {ok=>0};
    my $nos = 0;
    
    
    if (defined $s) {
        # optional safety - must replace such dige
        my $pa = $c->param('parent');
        if ($pa && $pa ne $cache->{"$f"} ) {
            $re->{er} = 'not ffwd';
            # could give out tree since...
            $s = '';
            # $re->{dige} = $cache->{"$f"} ;
        }
        elsif (!length $s) {
            `rm $t/1`;
            $re->{ok} = 'deleted';
        }
        else {
            # the whole name is directory
            -d $t || `mkdir -p $t`;
            my $new = !-f $f;
            $s = "$s\n" if $s !~ /\n$/;
            
            write_file("$f\.1",encode_utf8($s));
            `mv $f\.1 $f`;
            
            # the .5 may be in the same request
            my $five = $c->param('fivestring');
            if ($five) {
                my $ff = "$t/5";
                write_file("$ff\.1",encode_utf8($five));
                `mv $ff\.1 $ff`;
            }
            
            # < (notify nearby others, who )+
            $re->{ok} = 'updated';
            $re->{ok} = 'created' if $new;
            $nos = 1;
        }
    }
    else {
        if (-f $f) {
            $s = decode_utf8(read_file($f));
            $re->{ok} = 'found';
        }
        else {
            $re->{er} = 'not found'
        }
    }
    if (length $s) {
        # it should have a dig
        my $dig = slm(12,
            $f =~ m{^W/spot/} ? dig($s)
            :
            dige($s)
        );
        $cache->{$f} = $dig;
        $re->{dige} = $dig;
        $re->{s} = $s;
        # if they know its hash, assume they don't need the string again
        if (my $ha = $c->param('have')) {
            delete $re->{s} if grep {$_ eq $dig} split "\t", $ha
        }
        # or if it was a write
        delete $re->{s} if $nos;
    }
    $c->render(text=>sjson($re));
};

#c /ghost/
any '/ghost/*w' => sub { my ($c) = @_;
    my $t = $c->param('w');
    # / in t not meaning directory
    (my $st = $t) =~ s/\W+/-/g;
    my $se = $c->param('se') || '*';
    my $s = $c->param('s');
    my $patch = $c->param('patch') && die "know patch";
    my $cache = $G->{ghostache} ||= {};
    my @opt = glob "G/$se/$st";
    die "multiple @opt" if @opt > 1;
    my $f = $opt[0] || '';
    my ($cat) = $f =~ /^G\/([^\/]+)\//;
    # < avoid some disking if $have
    my $wig = "wormhole/digway/$st";
    my $digway = readlink($wig) || '';
    
    # returns json:
    my $re = {ok=>0};
    my $was_write = 0;
    
    # hasghost
    if (defined $s) {
        # optional safety - must replace such dige
        my $pa = $c->param('parent');
        if ($se eq '*') {
            $re->{er} = "!se param: writing G/\$se/\$t";
            $s = '';
        }
        elsif ($pa && $pa ne $cache->{"$f"} ) {
            if (!$cache->{"$f"} ) {
                $re->{er} = "lookup first";
                # < or trust digway?
            }
            else {
                $re->{er} = 'not ffwd';
            }
            # could give out tree since...
            $s = '';
            # $re->{dige} = $cache->{"$f"} ;
        }
        elsif (!length $s) {
            -f $f && `rm $f`;
            $re->{ok} = 'deleted';
        }
        else {
            # non-name is directory
            (my $dir = $f) =~ s/\/[^\/]+$//;
            -d $dir || `mkdir -p $dir`;
            my $new = !-f $f;
            #$s = "$s\n" if $s !~ /\n$/;
            
            write_file("$f\.1",encode_utf8($s));
            `mv $f\.1 $f`;
            
            # < (notify nearby others, who )+
            $re->{ok} = 'updated';
            $re->{ok} = 'created' if $new;
            $was_write = 1;
            
            my $mv = $c->param('gitmv');
            if ($mv) {
                my $m = "$dir/$mv";
                while ($m) {
                    sayre("no $m to move from")
                        && last unless -f $m;
                    
                    my $dif = `diff $f $m`;
                    sayre("$f<-$mv not up to date:\n".$dif)
                        && last if $dif =~ /\S/;
                    
                    `rm $f`;
                    my $move = `git mv $m $f`;
                    sayre("$f<-$mv git mv noise:\n".$move)
                        && last if $move =~ /\S/;
                    $m = ''
                }
            }
        }
    }
    else {
        if ($f && -f $f) {
            $s = decode_utf8(read_file($f));
            $re->{ok} = 'found';
        }
        else {
            $re->{er} = 'not found'
        }
    }
    if (length $s) {
        my $dig = dige($s);
        $cache->{$f} = $dig;
        if ($dig ne $digway) {
            -l $wig && `unlink $wig`;
            `ln -s $dig $wig`;
        }
        $re->{dige} = $dig;
        die "no cat: $f" if !$cat;
        $re->{se} = $cat;# if $cat ne $se;
        $re->{s} = $s;
        # they know string if:
        if (my $ha = $c->param('have')) {
            # they know its hash
            delete $re->{s} if grep {$_ eq $dig} split "\t", $ha
        }
        if ($was_write) {
            # they just sent it
            delete $re->{s};
            # speed /digwaypol/
            $poll->{doing}() if $poll->{ways} && $poll->{ways}->{"$t"};
        }
        
    }
    $c->render(text=>sjson($re));
};

#c /way/ $A->{4}->{sc}->{waythe} way!
any '/JaBabz/*W' => sub { my ($c) = @_;
    my $t = $c->param('W');
    my $w = $c->param('s');
    
    my $dige = dige($w);
    my $cache = $G->{Babache} ||= {};
    $w = $cache->{"$dige"} ||= do {
        $w = djson($w);
        babz($w);
        sjson($w)
    };
    
    $c->render(text=>$w);
};
sub babz {
    my $C = shift;
    # this line is compiled to JaBabz($C):
    JaBabz($C);
    $C->{c}->{s}
}
sub away {
    my $t = shift;
    my $ot = $t;
    $t =~ s/\W+/-/g;
    my $w;
    for ('G/*','wormhole/way') {
        my @opt = glob "$_/$t";
        my $f = shift @opt;
        next if !$f || !-f $f;
        # $w->{t} will be pi/thing, t (on disk) is pi-thing
        $w = {t=>$ot,y=>{}};
        $w->{c}->{s} = decode_utf8(read_file($f));
        $w->{sc}->{dige} = slm(12, dig $w->{c}->{s});
        $w->{sc}->{of} = 'w';
        last
    }
    $w || return;
    
    # < JaBabz is final
    my $babv = readlink("wormhole/digway/JaBabz");
    $A->{sc}->{wayjs} = {} if !$A->{sc}->{babv} || $A->{sc}->{babv} ne $babv;
    $A->{sc}->{babv} = $babv;
    # swap s just read for s compiled against its t/dige
    $w->{c}->{s} = $A->{sc}->{wayjs}->{"$w->{t}"}->{"$w->{sc}->{dige}"} ||= babz($w);
    return $w
};
get '/way/*way' => sub { my ($c) = @_;
    my $t = $c->param('way');
    my $w = away($t);
    $w || return $c->reply->not_found;
    
    $c->res->headers->append(Dige => $w->{sc}->{dige});
    
    my $have = $c->param('have');
    if ($have && $have eq $w->{sc}->{dige} ) {
        return $c->render(text => '')
    }
    $c->render(text => $w->{c}->{s});
};
get '/wayjs/#dige/#args/*way' => sub { my ($c) = @_;
    my $t = $c->param('way');
    my $w = away($t);
    # must be that version
    $w && $c->param('dige') eq $w->{sc}->{dige}
        || return $c->reply->not_found;
    # put in a global namespace
    my $name = join("__",'w',$t,
        $c->param('dige'),$c->param('args'));
    $name =~ s/\W+/_/g;
    my $s = "function $name(A,C,G,T,"
        .$c->param('args').") {\n".$w->{c}->{s}."\n}\n";
    $c->render(text => $s);
};
get '/wjs/*way' => sub { my ($c) = @_;
    my $wayish = $c->param('way');
    $wayish =~ s/\.js$//;
    my ($t,$args,$dige) = split "__", $wayish;
    
    my $w = away($t);
    $dige ||= '';
    1 && saybl $c->param('way')."  ->  $t  $args  $dige";
    
    # must be that version
    if (!$w) {
        1 && sayre "404 $t";
        return $c->reply->not_found
    }
    if ($dige && $dige ne $w->{sc}->{dige}) {
        1 && sayre "moved $t $dige -> $w->{sc}->{dige}";
        return $c->reply->not_found
    }
    $dige = $w->{sc}->{dige};
    $w->{sc}->{args} = $args;
    
    # put in a global namespace
    my $name = join("__",'w',$t,$args,$dige);
    $name =~ s/\W+/_/g;
    
    my $s = "function $name(A,C,G,T,$args) {\n".$w->{c}->{s}."\n}\n";
    
    $c->res->headers->append(sc => sjson($w->{sc}));
    $c->render(text => $s);
};

starts();