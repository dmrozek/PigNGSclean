DEFINE loadPairedEnd(path1, path2) RETURNS d1, d2 {
    $d1 = LOAD '$path1' USING udfs.FastqRowLoader();
    $d2 = LOAD '$path2' USING udfs.FastqRowLoader();
};

DEFINE loadPairedEndFastq(path1, path2) RETURNS d1, d2 {
    $d1 = LOAD '$path1' USING udfs.FastqLoader();
    $d2 = LOAD '$path2' USING udfs.FastqLoader();
};

DEFINE processPairedEnd(d1, d2, trimConfig) RETURNS o1, o2 {
    DEFINE trim udfs.PairedEndTrimmer('$trimConfig'); 
    
    pairs = JOIN $d1 BY header, $d2 BY header;
    flat = FOREACH pairs GENERATE TOTUPLE($d1::header, $d1::sequence, $d1::quality, $d2::header, $d2::sequence, $d2::quality);
    validated = FOREACH flat GENERATE udfs.PairedEndValidator();
    trimmed = FOREACH validated GENERATE trim();
    
    $o1 = FOREACH trimmed GENERATE TOTUPLE($0.header1,$0.sequence1,$0.quality1);
    $o2 = FOREACH trimmed GENERATE TOTUPLE($0.header2,$0.sequence2,$0.quality2);
};

DEFINE storePairedEnd(o1, o2, path1, path2) RETURNS void {
    STORE $o1 INTO '$path1' USING udfs.FastqRowStorer();
    STORE $o2 INTO '$path2' USING udfs.FastqRowStorer();
};

DEFINE storePairedEndFastq(o1, o2, path1, path2) RETURNS void {
    STORE $o1 INTO '$path1' USING udfs.FastqStorer();
    STORE $o2 INTO '$path2' USING udfs.FastqStorer();
};

DEFINE loadSingleRead(path) RETURNS d {
    $d = LOAD '$path' USING udfs.FastqRowLoader();
};

DEFINE loadSingleReadFastq(path) RETURNS d {
    $d = LOAD '$path' USING udfs.FastqLoader();
};

DEFINE processSingleRead(d, trimConfig) RETURNS o {
    DEFINE trim udfs.SingleReadTrimmer('$trimConfig'); 
    
    trimmed = FOREACH $d GENERATE trim(*);
    
    $o = FOREACH trimmed GENERATE TOTUPLE($0.header, $0.sequence, $0.quality);
};

DEFINE storeSingleRead(o, path) RETURNS void {
    STORE $o INTO '$path' USING udfs.FastqRowStorer();
};

DEFINE storeSingleReadFastq(o, path) RETURNS void {
    STORE $o INTO '$path' USING udfs.FastqStorer();
};
