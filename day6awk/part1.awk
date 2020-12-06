# gawk -f part1.awk < input

BEGIN {
    total = 0;
}
{
    split($0, chars, "");
    for (i = 1; i <= length($0); ++i) {
        counts[chars[i]] = 1;
    }
}
/^$/ {
    # End of group
    total += length(counts);
    delete counts;
}
END {
    total += length(counts);
    print total;
}
