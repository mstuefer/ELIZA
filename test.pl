
use strict;
use warnings;

use Assistant::Eliza::Assistant;

my $assistant = Assistant::Eliza::Assistant->new(
    script => './eliza_doctor_simple.txt',
);

$assistant->init();
$assistant->process();

# 01. Read the script file
# 02. Get user input line, split in words,
# 03. a set of pre-substitutions takes place
# 04. take all the words in sentence and make a list of all keywords
# 05. sort them in descending weight
# 06. process keywords until a output is produced
# 07. For a given keyword a list of decomposition patterns is searched
#     first one that matches is selected
# 08. For matching decomposition pattern a reassembly pattern is selected
# 09. A set of post-substitutions takes place
# 10. display result/output
