/* Credit: https://gist.github.com/simonsmith/5089415 */
/*
    @get
        xhr:
            url: 'path/to/json'
            data:
        events:
            done:   'dataResourceLoadDone',
            before: 'dataResourceLoadBefore'
        meta:
            id: 'request-1',
            page: 'index-app'

    Note: event handler should have three parameters: (e, data, meta)
*/
ajaxMixin = function() {
    this.get = function(options) {
        this.ajax(options, 'get');
    };

    this.post = function(options) {
        this.ajax(options, 'post');
    };

    this.ajax = function(options, type) {
        var xhr = $.extend(options.xhr, {
            context: this,
            type: type,
            dataType: 'json'
        });
        var events  = options.events;
        var meta = (typeof options.meta === 'object' ? options.meta : {});

        if (typeof events.before === 'string') {
            this.trigger(events.before);
            delete events.before;
        }

        var req = $.ajax(xhr);
        $.each(events, function(key, value) {
            if (typeof value === 'string') {
                req[key](function() {
                    // Push meta data in as second member for cleaner
                    // callback params
                    var args = [].slice.call(arguments, 0);
                    args.splice(1, 0, meta);

                    this.trigger(value, args);
                });
            }
        });
    };
};

