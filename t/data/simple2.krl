// simple inactive rule 
ruleset 10 {
    rule test0 is inactive {
        select using "/test/"
        replace("test","test");
    }
}
 
