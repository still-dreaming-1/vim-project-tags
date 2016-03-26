# vim-project-tags [![Join the chat at https://gitter.im/still-dreaming-1/vim-project-tags](https://badges.gitter.im/still-dreaming-1/vim-project-tags.svg)](https://gitter.im/still-dreaming-1/vim-project-tags?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
An improved tags experience based on the concept of projects.

This will search for your project root and save separate tag files for PHP and JavaScript files. It assumes the existence of a .git directory indicates your project root. Creates the tag files automatically when you save. If you save a .php file, it only creates tags for other .php files in the project, and saves them in their own phptags file. If you save a .js file, it generates tags in a separate jstags file. When you are editing a file, and try to do a code lookup using tags, it will only search one tags file matching the language of the file you are editing, based on file extension. The point of all this is to avoid false positives and keep the tag matches to a minimum.

Out of the box, this only supports JavaScript and PHP. But you can easily add support for any taggable language yourself. Just call the `project_tags#add_extension()` function in your config and pass it a string with the file extension of the language you want to create tags for. Call it again for each language. This only works for languages that rely on a single file extension. In other words, it won't work with c because it is split between .c and .h files. Here is an example that adds support for python:

`call project_tags#add_extension('py')`

You can also provide a custom executable name or full path to to your ctags. Example:

`let g:project_tags_ctags_path= 'myctags'`

Installation:

Install it the normal way you install Vim plugins. This also depends on the vim-elhiv plugin, so you will have to install that as well. https://github.com/still-dreaming-1/vim-elhiv/tree/master

**Coming soon:**
* Define your project structure for an even better tags experience.
