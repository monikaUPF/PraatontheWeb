# PraatontheWeb
Web implementation of Praat. Source code, running demo scripts on web, samples and documentation
The link to the web application is http://kristina.taln.upf.edu/praat_web/
###############
This repository includes the following items:
- PraatWeb.zip: source code with the web implementation of the extended version of Praat for feature annotation. 
- Modular Prosody Tagger: a collection of 8 Praat scripts for the two possible configurations of the tagger. Users can access this tool online clicking on Enter Demo 2 in the main menu of Praat on the Web link mentioned above.
    -  Word Segments: this configuration takes the following 6 modules. This pipeline performs prediction of Prosodic phrases (PPh) boundaries and prominence based on word segmentas and acoustic information.
        -  "mod01.praat" Module 1: Intensity Peak Detection
        -  "mod02.praat" Module 2: Intensity Valley Detection
        -  "mod03.praat" Module 3: Feature Annotation
        -  "mod04.praat" Module 4: Word Segment Export
        -  "mod05a.praat" Module 5: PPh boundary detection (word segments)
        -  "mod06a.praat" Module 6: PPh prominence detection (word segments)
    -  Raw Speech: this configuration takes the following 5 modules and performs prediction of Prosodic phrases boundaries and prominence on computed intensity peaks and valleys
        -  "mod01.praat" Module 1: Intensity Peak Detection
        -  "mod02.praat" Module 2: Intensity Valley Detection
        -  "mod03.praat" Module 3: Feature Annotation
        -  "mod05b.praat" Module 5: PPh boundary detection (raw speech)
        -  "mod06b.praat" Module 6: PPh prominence detection (raw speech)



