from std.collections import Set, List

def get_default_stopwords() -> Set[String]:
    """Returns a Set containing standard English stopwords."""
    var s = Set[String]()
    var raw = (
        "a about above after again against all am an and any are aren't as at be"
        " because been before being below between both but by can can't cannot"
        " could couldn't did didn't do does doesn't doing don't down during each"
        " few for from further had hadn't has hasn't have haven't having he he'd"
        " he'll he's her here here's hers herself him himself his how how's i"
        " i'd i'll i'm i've if in into is isn't it it's its itself let's me more"
        " most mustn't my myself no nor not of off on once only or other ought"
        " our ours ourselves out over own same shan't she she'd she'll she's"
        " should shouldn't so some such than that that's the their theirs them"
        " themselves then there there's these they they'd they'll they're they've"
        " this those through to too under until up very was wasn't we we'd we'll"
        " we're we've were weren't what what's when when's where where's which"
        " while who who's whom why why's with won't would wouldn't you you'd"
        " you'll you're you've your yours yourself yourselves will shall"
    )

    var words = raw.split(" ")
    for i in range(len(words)):
        s.add(String(words[i]))
    return s^

def create_stopwords(custom: List[String], include_default: Bool = True) -> Set[String]:
    """Creates a custom stopword Set, optionally starting with default stopwords."""
    var s = Set[String]()
    if include_default:
        s = get_default_stopwords()
    for i in range(len(custom)):
        s.add(custom[i].lower())
    return s^

def add_stopwords(mut stopwords: Set[String], words: List[String]):
    """Adds words to an existing stopword Set in-place."""
    for i in range(len(words)):
        stopwords.add(words[i].lower())

def remove_stopwords(mut stopwords: Set[String], words: List[String]):
    """Removes words from an existing stopword Set in-place if present."""
    for i in range(len(words)):
        var w = words[i].lower()
        if w in stopwords:
            try:
                stopwords.remove(w)
            except:
                pass
