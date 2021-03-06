parse.punt = function(pbp, play) {
    play$punt = FALSE
    play$faircatch = NA

    punt_regex = paste("(?<punter>[-a-zA-Z\\. ']+) punt for (?<kickdist>\\d{1,3}) ",
        "(yd|yard)s?(.*(?<touchback>touchback).*|.*out[- ]of[- ]bounds at|.*fair catch by ",
        "(?<catcher>[-a-zA-Z\\. ']+) at|.*returned by (?<returner>[-a-zA-Z\\. ']+) ",
        "for (((?<retgain>\\d{1,3}) (yd|yard)s|(a )?loss of (?<retloss>\\d+) ",
        "(yd|yard)s?|(?<retnogain>no gain)))?)?", sep='')

    if (grepl(punt_regex, pbp, perl=TRUE, fixed=FALSE, ignore.case=TRUE)) {
        match = regex(punt_regex, pbp, perl=TRUE, fixed=FALSE, ignore.case=TRUE)
        play$punt = TRUE
        play$kicker = match[1,'punter']
        play$returner = match[1,'returner']
        play$kick_dist = match[1,'kickdist']

        if (!is.na(match[1,'touchback'])) {
            play$touchback = TRUE
            play$kick_return = 0
        } else {play$touchback = FALSE}
    
        if (!is.na(match[1,'catcher'])) {
            play$faircatch = TRUE
            play$returner = match[1,'catcher']
            play$kick_return = 0
        } else {play$faircatch = FALSE}

        if (!is.na(match[1,'retgain'])) {play$kick_return = as.numeric(match[1,'retgain'])}
        else if (!is.na(match[1,'retloss'])) {play$kick_return = -as.numeric(match[1,'retloss'])}
        else if (!is.na(match[1,'retnogain'])) {play$kick_return = 0}
    }
    
    return(play)
}