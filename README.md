# vim-project-tags [![Join the chat at https://gitter.im/still-dreaming-1/vim-project-tags](https://badges.gitter.im/still-dreaming-1/vim-project-tags.svg)](https://gitter.im/still-dreaming-1/vim-project-tags?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
An improved tags experience based on the concept of projects.

This will search for your project root and save separate tag files for PHP and JavaScript files. You need to create a file named ".project_tags.config.vim" and place it in the project root directory of code projects you wish to use this plugin with. For now, this just tells the plugin which directory is your project root. This plugin creates tag files automatically when you save code files. If you save a .php file, it only creates tags for other .php files in the project, and saves them in their own phptags file. If you save a .js file, it generates tags in a separate jstags file. When you are editing a file, and try to do a code lookup using tags, it will only search one tags file matching the language of the file you are editing, based on file extension. The point of all this is to avoid false positives and keep the tag matches to a minimum.

Out of the box, this only supports JavaScript and PHP. But you can easily add support for any taggable language yourself. Just call the `project_tags#add_extension()` function in your config and pass it a string with the file extension of the language you want to create tags for. Call it again for each language. This only works for languages that rely on a single file extension. In other words, it won't work with c because it is split between .c and .h files. Here is an example that adds support for python:

`call project_tags#add_extension('py')`

You don't need to worry about whether you are adding support for an already supported language. If you call that function with a duplicate file extension, it will just be ignored. This means that if you prefer, you can just call that function for each file extension you want to create tags for without worrying about whether or not the plugin already has built in support for that language.

You can also provide a custom executable name or full path to to your ctags. Example:

`let g:project_tags_ctags_path= 'myctags'`

**Installation**

Install it the normal way you install Vim plugins. This also depends on the [vim-elhiv](https://github.com/still-dreaming-1/vim-elhiv/tree/master) plugin, so you will have to install that as well. You need to create a file named ".project_tags.config.vim" and place it in the project root directory of code projects you whish to use this plugin with.

**Coming soon**
* The master branch will only ever point to the latest release, so it should be more fit for production use. The develop branch will contain the latest unreleaed commits.
* More automated tests to keep the master branch more stable.
* Continous integration to keep the master branch more stable.
* Optionally define your project structure inside your ".project_tags.config.vim" files for an even better tags experience.

**Versions**

I recommend just using the latest commit on the master branch. That way it will work correctly with the latest commit on the master branch of the vim-elhiv library plugin. I haven't yet figured out a good way to tie specific version releases to a specific version of vim-elhiv. If you want to use a specific version you will have to compare the commit date and time to that of the commits to vim-elhiv and try it with the vim-elhiv commit just before the vim-project-tags release. If that doesn't work sometimes I find a bug in vim-elhiv and quickly fix it so it may work better with the following vim-elhiv commit. Currently I am working on adding automated tests to keep the master branch more stable.
