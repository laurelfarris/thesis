;-
;- 14 May 2020
;-
;-
;- [] Prep for new science by commenting and outlining potential codes,
;-      new analysis methods, re-structure old methods (not just the science
;-      part, but also improve genearality of subroutines (can use for any flare),
;-      sort stand-alone bits into (or out of) subroutines, depending on
;-      computational efficiency, memory useage, and most importantly,
;-     ease with which poor simple-minded user (me) is able to ascertain the
;-     purpose, input/output, calling syntax, etc. VERY quickly and can use
;-     it immediately after a long hiatus, preferably with no errors due to
;-     use of variable names/types or filenames that have since been changed,
;-     calls to routines that don't even exist anymore or were absorbed into
;-     another file, kws/args added or taken away, pros changed to funcs or
;-     vice versa... always something.
;-     -
;-     -
;-
;-  What TYPE of results do I want to show for next research article?
;-  Depends on what I'm trying to accomplish, or what science questions
;-  I want to answer. So sort that out, THEN decide what figures to make at first.
;-  Answer the following questions (maybe a writing prompt or two?):
;-    • How will the science Qs posed in this study (and thesis in general)
;-      be answered by the values derived, relationships revealed in plots,
;-      or patterns displayed over images?
;-    •
;-    •
;-
;- TO DO:
;-  [] see @Lit for tons of ideas
;-  [] Enote with collection of figure screenshots from variety of @Lit:
;-     can be relevant to my research/methods or just nice graphics.
;-  [] Codes/ATT/, other Figure ideas written in Enote, Greenie, wherever,
;-     then generate as MANY as possible with sense of urgency.
;-     GOAL is to have ugly-ass graphics plagued by IDL's horrendous defaults,
;-       ~ podcast about forcing yourself NOT to run farther than the edge
;-          of your lawn if you're one of those all-or-nothing perfectionists.
;-


;+
;- 30 January 2021
;-
;-   IDEA for possibly making my life so much easier:
;-     Modify INDEX returned from READ_SDO instead of defining my own structures
;-     from scratch? Retain the few tags I need:
;-       • -> SAFER! No risk of entering incorrect numbers
;-           (like reversing the exptime for 1600 and 1700 ...)
;-       • Will save so much time w/o repeatedly looking up fits filename syntax,
;-         read_my_fits syntax, high CPU and memory useage to read large files,
;-         (even with /nodata set, still takes forever.)
;-
;-  [] Learn how to modify/update structures,  tho?
;-      Remove tags, add new tags,
;-      Combine multiple strucs into one master struc or array, 
;-      Syntax to access tags/values using tagnames OR index, eg "struc.(ii)"
;-      
;-


end
