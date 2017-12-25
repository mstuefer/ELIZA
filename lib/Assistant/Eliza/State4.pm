package Assistant::Eliza::State4;

use Moose;

with 'Assistant::Eliza::Staterole';

# print answer
sub process {
    my ($self, $ass, $input) = @_;

    print "\n\t".($ass->current_answer ? $ass->current_answer : "Please elaborate on this")."\n\n";
    $ass->current_answer('');

    $ass->state(Assistant::Eliza::State7->new());
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
