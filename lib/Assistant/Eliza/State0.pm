package Assistant::Eliza::State0;

use Switch;
use Moose;

with 'Assistant::Eliza::Staterole';

has 'current_key' => (
    is  => 'rw',
    isa => 'Str',
);

has 'current_key_decomp' => (
    is  => 'rw',
    isa => 'Str',
);

sub process {
    my ($self, $ass) = @_;

    open(my $fh, '<:encoding(UTF-8)', $ass->script)
        or die "$ass->script not found";

    while(my $row = <$fh>) {
        $row =~ s/^\s+//; # remove leading whitespaces
        my ($k, $v) = split /\s*:\s*/, $row, 2;
        $self->_clean(\$k, \$v);
        switch($k) {
            case "initial"  { $self->_add_arr_value($ass, $k, $v) }
            case "fnl"      { $self->_add_arr_value($ass, $k, $v) }
            case "quit"     { $self->_add_arr_value($ass, $k, $v) }
            case "pre"      { $self->_add_key($ass, $k, $v) }
            case "post"     { $self->_add_key($ass, $k, $v) }
            case "synon"    { $self->_add_synon($ass, $k, $v) }
            case "key"      { $self->_add_key($ass, $k, $v) }
            case "decomp"   { $self->_add_key_decomp($ass, 'keywords', $v) }
            case "reasmb"   { $self->_add_key_reasmb($ass, 'keywords', $v) }
            else            { $self->_not_found($ass, $v) }
        }
    }

    #print "Welcome, how can I help you?\n\n";
    $self->_welcome($ass);

    #print STDERR Data::Dumper::Dumper $ass;
    $ass->state(Assistant::Eliza::State1->new());
}

sub _clean {
    ${$_[1]} = 'fnl' if( ${$_[1]} eq 'final' ); # overwrite final with fnl as key
    chomp(${$_[2]}); # remove \n on value
}

sub _add_arr_value {
    my ($self, $ass, $key, $val) = @_;
    push(@{ $ass->$key }, $val);
}

sub _add_key {
    my ($self, $ass, $key, $val) = @_;
    switch($key) {
        case "pre"      { $self->_add_key_pre($ass, $key, $val) }
        case "post"     { $self->_add_key_post($ass, $key, $val) }
        case "key"      { $self->_add_key_key($ass, 'keywords', $val) }
    }
}

sub _add_key_pre {
    my ($self, $ass, $key, $val) = @_;
    my ($w1, $w2) = split(/\s* \s*/, $val, 2);
    ${ $ass->$key }{$w1} = $w2;
}

sub _add_key_post {
    $_[0]->_add_key_pre($_[1], $_[2], $_[3]);
}

sub _add_key_key {
    my ($self, $ass, $key, $val) = @_;
    my ($word, $weight) = split(/\s* (\d+)/, $val, 2);
    $self->current_key($word);
    $weight = 0 unless(defined($weight));
    ${ $ass->$key }{ $word } = { weight => $weight, decomp => {} };
}

sub _add_key_decomp {
    my ($self, $ass, $key, $val) = @_;
    $val =~ s/\*/(.*)/g; # substitude * with .*
    ${ $ass->$key }{ $self->current_key }{ decomp }{ $val } = [];
    $self->current_key_decomp($val);
}

sub _add_key_reasmb {
    my ($self, $ass, $key, $val) = @_;
    push(
        @{${$ass->$key}{$self->current_key}{decomp}{$self->current_key_decomp}},
        $val
    );
    # TODO  create possibility to count how often we have chosen the reasmb,
    #       s.t. we use them all once before repeating
    #push(
    #    @{${$ass->$key}{$self->current_key}{decomp}{$self->current_key_decomp}},
    #    { $val => 0 }
    #);
}

sub _add_synon {
    my ($self, $ass, $key, $val) = @_;
    foreach my $w (split ' ', $val) {
        @{ ${ $ass->$key }{$w} } = grep { $_ ne $w } (split ' ', $val);
    }
}

sub _not_found {
    my ($self, $ass, $row) = @_;
    print STDERR "Could not elaborate $row\n";
}

sub _welcome {
    print @{ $_[1]->initial }[ rand @{ $_[1]->initial } ];
    print "\n\n";
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
