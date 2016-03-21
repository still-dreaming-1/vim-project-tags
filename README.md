# vim-project-tags [![Join the chat at https://gitter.im/still-dreaming-1/vim-project-tags](https://badges.gitter.im/still-dreaming-1/vim-project-tags.svg)](https://gitter.im/still-dreaming-1/vim-project-tags?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
An improved tags experience based on the concept of projects.

This will search for your project root and save separate tag files for PHP and JavaScript files. It assumes the existence of a .git directory indicates your project root. Creates the tag files automatically when you save. If you save a .php file, it only creates tags for other .php files in the project, and saves them in their own phptags file. If you save a .js file, it generates tags in a separate jstags file. When you are editing a file, and try to do a code lookup using tags, it will only search one tags file matching the language of the file you are editing, based on file extension. The point of all this is to avoid false positives and keep the tag matches to a minimum.

**Coming soon:**
* Define your project structure for an even better tags experience.
* Option to overwrite the ctags executable name.
* Easily add support for any taggable language yourself.
