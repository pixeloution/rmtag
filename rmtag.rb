#!/usr/bin/env ruby
    
    # handles command line options
    require 'getoptlong'

class Deleter
    # the public entry point
    def run
        options = parseOptions()
        options['help'] && outputHelp()

        validateArgs()
        minimum = Gem::Version.new( ARGV[0] )
        maximum = Gem::Version.new( ARGV[1] )

        deleteTags( minimum, maximum, options['execute'] )
    end

    protected
    #
    # deletes the tags, optionally only outputs the 
    # commands that would be executed, for the truly paranoid
    # 
    def deleteTags min, max, execute
        tagsToDelete = `git tag`.split( /\s+/ ).select do |tag| 
            tag = Gem::Version.new(tag)
            tag >= min && tag <= max
        end

        commands = [
            "git tag -d " + tagsToDelete.join(' '),
            "git push origin " + tagsToDelete.map { |tag| ':' + tag }.join(' ')
        ]

        commands.each do | command |
            puts command

            if execute
                `#{command}`
                puts 'executed !'
            end
        end
    end

    #
    # application requires that two arguments be provided; both
    # start tag and end tag
    # 
    def validateArgs
        if ( ! ARGV[0] || ! ARGV[1])
            abort "must provide two version numbers. try: tagdeleter.rb --help"
        end
    end

    #
    # uses the getoptlog library to parse
    # the --test and --help options
    # 
    def parseOptions
        opts = GetoptLong.new(
            [ '--test', '-t', GetoptLong::NO_ARGUMENT ],
            [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
            [ '--execute', '-e', GetoptLong::NO_ARGUMENT ]
        )
            
        options = Hash.new
        
        opts.each do | optionName, argument |
            options[optionName.gsub('--', '')] = true
        end

        options['test']    = options['test'] || false
        options['execute'] = options['execute'] || false
        options['help']    = options['help'] || false

        return options
    end

    # 
    # outputs help text
    # 
    def outputHelp
        output = <<-EOF

        \033[1mNAME\033[0m

            rmtag

        \033[1mSYNOPSIS\033[0m

            rmtag --execute minVersion maxVersion
            rmtag --test minVersion maxVersion

        \033[1mDESCRIPTION\033[0m

            when run within a directory version controlled by git, deletes all tags
            between minVersion and maxVersion, \033[1mincluding\033[0m exact
            matches for minVersion and maxVersion

        \033[1mOPTIONS\033[0m    

            -h, --help
            show this help file

            -e, --execute
            run the commands generated by the program

            -t, --test
            only output the commands to stdout, do not run them. this is the default mode
            if --execute is not specified.

        EOF
        
        puts output.gsub( /^        /, '' )
        abort
    end
end



    # do stuff
    deletions = Deleter.new
    deletions.run()
