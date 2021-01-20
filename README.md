<p align="center">
    <em>Rasa NLU engine backported from main Rasa project</em>
</p>
<p align="center">
<a href="https://travis-ci.org/madkote/rasa-nlu-contrib" target="_blank">
    <img src="https://travis-ci.org/madkote/rasa_nlu_contrib.svg?branch=master" alt="Build Status">
</a>
<a href="https://codecov.io/gh/madkote/rasa-nlu-contrib" target="_blank">
    <img src="https://codecov.io/gh/madkote/rasa_nlu_contrib/branch/master/graph/badge.svg" alt="Coverage">
</a>
<a href="https://pypi.org/project/rasa-nlu-contrib" target="_blank">
    <img src="https://img.shields.io/pypi/v/rasa_nlu_contrib.svg" alt="Package version">
</a>
</p>

# rasa-nlu-contrib
Rasa NLU engine backported from main Rasa project

Rasa NLU (Natural Language Understanding) is a tool for understanding what is being said in short pieces of text.
For example, taking a short message like:

> *"I'm looking for a Mexican restaurant in the center of town"*

And returning structured data like:

```
  intent: search_restaurant
  entities: 
    - cuisine : Mexican
    - location : center
```

Rasa NLU is primarily used to build chatbots and voice apps, where this is called intent classification and entity extraction.
To use Rasa, *you have to provide some training data*.
That is, a set of messages which you've already labelled with their intents and entities.
Rasa then uses machine learning to pick up patterns and generalise to unseen sentences. 

You can think of Rasa NLU as a set of high level APIs for building your own language parser using existing NLP and ML libraries.

# License
This project is licensed under the terms of the MIT license.
Code of Rasa is licensed under the terms of the Apache 2.0 license.
[Copy of the license](LICENSE) and [additional notes](NOTICE).

## Installation
...

## Changes
See [release notes](CHANGES.md)

# Development and how to contribute
Issues and suggestions are welcome through *issues*
