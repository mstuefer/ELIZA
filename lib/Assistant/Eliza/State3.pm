package Assistant::Eliza::State3;

use Moose;

with 'Assistant::Eliza::Staterole';

# TODO split in additional states

# -- For a given keyword a list of decomposition patterns is searched
#    first one that matches is selected
# -- For matching decomposition pattern a reassembly pattern is selected
# -- A set of post-substitutions takes place TODO
sub process {
    my ($self, $ass, $input) = @_;

    foreach my $keyword (@{ $ass->current_keywords }) {
        $self->_process_keyword($ass, $input, $keyword)
            unless($ass->current_answer);
    }

    $ass->state(Assistant::Eliza::State4->new());
}

# TODO save which decomp was already used, use them all before reusing one
sub _process_keyword {
    my ($self, $ass, $input, $w) = @_;
    $w = lc($w);

    LINE: foreach my $decomp ( keys %{ $ass->{keywords}{$w}{decomp} } ) {
        next LINE unless (join(" ", @{ $ass->input_words }) =~ /$decomp/);

        #$ass->last_decomp($decomp);

        # define all wildcards to possibly substitude later
        @{ $ass->current_wildcards } = join(" ", @{ $ass->input_words }) =~ /$decomp/;

        # define a random answer
        my @arr = @{ $ass->{keywords}{$w}{decomp}{$decomp} };
        $ass->current_answer($arr[rand @arr]);

        # next if chosen answer does not contain anything to substitude
        next LINE unless($ass->current_answer =~ m/(\d+)/);

        # substitude placeholders
        my $sub = defined @{ $ass->current_wildcards }[($1 -1)] ? @{ $ass->current_wildcards }[($1 - 1)] : "mmmmm";
        my $res = $ass->current_answer;
        $res =~ s/\(\d+\)/$sub/;
        $ass->current_answer($res);
    }

}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
