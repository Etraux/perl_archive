use Date::Manip::Date; 
$d = Date::Manip::Date->new; 
for (36,18,-17,7,-45) { 
    $d->parse(111111 . $_); 
    print substr $d->printf("%j%a%p%h" x 4), -$_, 1; 
} 
print "\n";