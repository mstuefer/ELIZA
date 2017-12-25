package Assistant::Eliza::State2;

use Moose;

with 'Assistant::Eliza::Staterole';

# make a list of all keywords in input sorted in descendent way
sub process {
    my ($self, $ass, $input) = @_;

    $self->_exit($ass) if @{ $ass->input_words }[0] eq 'quit';

    undef @{ $ass->current_keywords };

    foreach my $w (@{ $ass->input_words }) {
        push(@{ $ass->current_keywords }, $w) if(defined(${$ass->keywords}{$w}));
    }

    @{ $ass->current_keywords } = sort
        { $ass->{keywords}{$b}->{weight} <=> $ass->{keywords}{$a}{weight} }
        @{ $ass->current_keywords};

    $ass->state(Assistant::Eliza::State3->new());
}

sub _exit {
    print @{ $_[1]->fnl }[ rand @{ $_[1]->fnl}  ];
    print "\n";
    print @{ $_[1]->quit }[ rand @{ $_[1]->quit }  ];
    print "\n\n";
    exit(0);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
