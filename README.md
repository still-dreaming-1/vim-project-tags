# vim-project-tags [![Join the chat at https://gitter.im/still-dreaming-1/vim-project-tags](https://badges.gitter.im/still-dreaming-1/vim-project-tags.svg)](https://gitter.im/still-dreaming-1/vim-project-tags?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
An improved tags experience based on the concept of projects.

This will search for your project root and save separate tag files per programming language for your source code. It works with all languages supported by ctags with the exception of languages requiring source code with more than one file extension like C and C++. This plugin creates tag files automatically when you save code files. If you save a .js file, it only creates tags for other .js files in the project, and saves them in their own jstags file. If you save a .php file, it generates tags in a separate phptags file. When you are editing a file, and try to do a code lookup using tags, it will only search one tags file matching the language of the file you are editing, based on file extension. The point of all this is to avoid false positives and keep the tag matches to a minimum. This allows code lookup using tags to behave more intelligently, closer to how code lookup would work in a smart IDE.

Out of the box, this only automatically generates tags for JavaScript and PHP. But you can easily use this plugin with other ctags compatible languages just by specifying file extensions you want to work with. Just call the `project_tags#add_extension()` function in your config and pass it a string with the file extension of the language you want to create tags for. Call it again for each language. This only works for languages that rely on a single file extension. In other words, it won't work with c because it is split between .c and .h files. Here is an example that adds support for python:

`call project_tags#add_extension('py')`

You don't need to worry about whether you are adding support for an already supported language. If you call that function with a duplicate file extension, it will just be ignored. This means that if you prefer, you can just call that function for each file extension you want to create tags for without worrying about whether or not the plugin already has built in support for that language.

You can also provide a custom executable name or full path to to your ctags, but you don't need to. Example:

`let g:project_tags_ctags_path= 'myctags'`

**Installation**

Install it the normal way you install Vim plugins. This also depends on the [vim-elhiv](https://github.com/still-dreaming-1/vim-elhiv/tree/master) plugin, so you will have to install that as well. You need to create a file named ".project_tags.config.vim" and place it in the project root directory of code projects you wish to use this plugin with.

**Coming soon**
* More options to define your project structure inside your project configuration files for an even better tags experience.

**Versions**

Use the latest commit on the master branch. The master branch is the stable branch. I only merge the develop branch into master after doing a release. The master branch works correctly with the latest master branch commit in the vim-elhiv library plugin. Unless you want to contribute code or help me debug, I don't recommend using the develop branch. If you do use the develop branch, realize it is designed to be used with the develop branch of the vim-elhiv library plugin. I haven't yet figured out a good way to tie specific tagged version releases to a specific tagged version of vim-elhiv. If you want to use an older tagged version you will have to compare the commit date and time to that of the commits to vim-elhiv and try it with the vim-elhiv commit just before the vim-project-tags tag/release. If that doesn't work sometimes I find a bug in vim-elhiv and quickly fix it so it may work better with the following vim-elhiv commit. I use automated tests to keep the latest version / master commit stable, so I really recommend just using that.

**Configuration**

You need to create a file named ".project_tags.config.vim" and place it in the project root directory of code projects you wish to use this plugin with. Be careful what you place in this file, as it will be sourced and ran as VimL code inside your Vim. The generated tags files will appear inside the same directory as your project configuration file.

Exclude directory option:

Inside the project configuration file, you have the option of excluding directories that you don't want to create tags from. Be careful what you place in this file, as it will be sourced and ran as VimL code inside your Vim. Here is an example of using the exclude directory option:
`let g:project_tags_exclude= ['mobile', 'generated_code']`
If you place that line inside your project configuration file, your tags files will not contain tag data from source files inside any subdirectories named "mobile" or "generated_code". The excluded directories will be treated as relative paths from the project file. This may be a useful feature if you frequently find yourself matching false positives when trying to do a code lookup based on tags and the false positives are all inside a specific directory. There is a very specific use case where this feature will be very useful after the include directory option is developed.

Include directory option:

Coming soon.
