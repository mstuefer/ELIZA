package Assistant::Eliza::State1;

use Moose;

with 'Assistant::Eliza::Staterole';

# split user input line in words and execute pre-substitutions
sub process {
    my ($self, $ass, $input) = @_;

    chomp($input);
    $ass->input_words( [ split / /, $input ] );

    map {
            $_=lc;
            s/[?!.,]//; # remove useless chars
            $ass->{pre}{$_} if defined $ass->{pre}{$_};
        } @{ $ass->input_words };

        $ass->state(Assistant::Eliza::State2->new());
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
