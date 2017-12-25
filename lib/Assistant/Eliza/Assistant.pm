package Assistant::Eliza::Assistant;

use Moose;

use Assistant::Eliza::State0;
use Assistant::Eliza::State1;
use Assistant::Eliza::State2;
use Assistant::Eliza::State3;
use Assistant::Eliza::State4;
use Assistant::Eliza::State7;

has 'script' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'initial' => (
    is      => 'rw',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
);

has 'fnl' => (
    is      => 'rw',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
);

has 'quit' => (
    is      => 'rw',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
);

has 'pre' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

has 'post' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

has 'synon' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

has 'keywords' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

has 'state' => (
    is  => 'rw',
    isa => 'Object',
);

has 'input_words' => (
    is  =>  'rw',
    isa =>  'ArrayRef[Str]',
);

has 'current_keywords' => (
    is      =>  'rw',
    isa     =>  'ArrayRef[Str]',
    default =>  sub { [] },
);

has 'current_answer' => (
    is      => 'rw',
    isa     => 'Str',
);

has 'current_wildcards' => (
    is      => 'rw',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
);

has 'last_decomp' => (
    is      => 'rw',
    isa     => 'Str',
);

# methods

# read/parse the script
sub init {
    my ($self) = @_;

    $self->state(Assistant::Eliza::State0->new());
    $self->state->process($self);
}

# process a given input, returning corresponding output
sub process {
    my ($self) = @_;

    my $start_state = Assistant::Eliza::State1->new();
    my $final_state = Assistant::Eliza::State7->new();

    while (<>) {
        do {
            $self->state->process($self, $_);
        } until( $self->state->isa(ref $final_state) );
        $self->state($start_state);
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
