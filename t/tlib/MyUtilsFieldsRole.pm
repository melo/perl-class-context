package MyUtilsFieldsRole;

use Moo::Role;
use Class::Context::Utils 'has_data_field';
use namespace::autoclean;

has '_test1_triggered' => (is => 'rw', default => sub {0});
sub test1_triggered { my ($self) = @_; my $v = $self->_test1_triggered; $self->_test1_triggered(0); return $v }

has_data_field 'test1' => (is => 'rw', trigger => sub { shift->_test1_triggered(1) });
has_data_field 'test2' => (is => 'rw');

1;
