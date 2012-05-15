These are prototyped state machines for records in ArchivesSpace.

Archival Objects
----------------

Archival objects have four possible states: *new*, *updated*, *suppressed*, and *deletion requested*; *deleted* is a pseudo-state that represents a destroyed object.

Archival objects have seven possible events: *update*, *deaccession*, *suppress*, *unsuppress*, *request deletion*, *cancel request*, and *destroy*.

![Archival Object record state](https://github.com/anarchivist/record-state/raw/master/img/ArchivalObject_state.png)

Accessions
----------

Accessions inherit directly from archival objects and have identical sets of states and events.

![Accession record state](https://github.com/anarchivist/record-state/raw/master/img/Accession_state.png)

Resources
---------

Resources inherit from a hierarchical subclass of ArchivalObject, which adds the *add child* event. It has an identical set of states to ArchivalObject and adds the following events: *transfer component*, *receive transfer*, *merge into other*, *receive merge*. 

![Resource record state](https://github.com/anarchivist/record-state/raw/master/img/Resource_state.png)

Digital objects
---------

Digital objects inherit from a hierarchical subclass of ArchivalObject, which adds the *add child* event; otherwise, events and states are the same as ArchivalObjects.

![Digital Object record state](https://github.com/anarchivist/record-state/raw/master/img/DigitalObject_state.png)

