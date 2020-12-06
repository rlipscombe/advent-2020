# gawk -f part2.awk < input

BEGIN {
    total = 0;
}

NF {
    split($0, chars, "");
    for (i = 1; i <= length($0); ++i) {
        counts[chars[i]]++;
    }
    size++;
}

function end_of_group() {
    everyone = 0;
    for (key in counts) {
        if (counts[key] == size) {
            everyone++;
        }
    }

    total += everyone;
    delete counts;
    size = 0;
}

/^$/ {
    end_of_group();
}

END {
    end_of_group();
    print total;
}
