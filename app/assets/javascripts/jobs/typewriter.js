$(document).ready(function() {
  // Add something to given element placeholder
  function addToPlaceholder(toAdd, el) {
    el.attr('placeholder', el.attr('placeholder') + toAdd);
    // Delay between symbols "typing" 
    return new Promise(resolve => setTimeout(resolve, 100));
  }

  // Cleare placeholder attribute in given element
  function clearPlaceholder(el) {
    el.attr("placeholder", "");
  }

  // Print one phrase
  function printPhrase(phrase, el) {
    return new Promise(resolve => {
        // Clear placeholder before typing next phrase
        clearPlaceholder(el);
        let letters = phrase.split('');
        // For each letter in phrase
        letters.reduce(
            (promise, letter, index) => promise.then(_ => {
                // Resolve promise when all letters are typed
                if (index === letters.length - 1) {
                    // Delay before start next phrase "typing"
                    setTimeout(resolve, 1000);
                }
                return addToPlaceholder(letter, el);
            }),
            Promise.resolve()
        );
    });
  } 

  // Print given phrases to element
  function printPhrases(phrases, el) {
    // For each phrase
    // wait for phrase to be typed
    // before start typing next
    phrases.reduce(
        (promise, phrase, index) => promise.then(_ => 
          { if (index === phrases.length - 1) {
            setTimeout(() => {
              run()
            }, 3000);
          }
          return printPhrase(phrase, el)
        }), 
        Promise.resolve()
    );
  }

  // Start typing
  function run() {
    let phrases = [
        "Frontend Developer",
        "UX Design",
        "Javascript",
        "Product Manager",
        "Barcelona",
        "Software Engineer",
        "Data Analysis",
        "Cybersecurity"
    ];

    printPhrases(phrases, $('#search'));
  }
  
  run();
});
