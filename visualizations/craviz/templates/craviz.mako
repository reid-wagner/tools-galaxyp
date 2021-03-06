<%
    default_title = "Cancer-Related Analysis of Variants Toolkit"
    info = hda.name
    if hda.info:
        info += ' : ' + hda.info

    # optionally bootstrap data from dprov
    data = list( hda.datatype.dataset_column_dataprovider( hda, limit=20 ) )

    root            = h.url_for( "/" )
    app_root        = root + "plugins/visualizations/craviz/static/js"
    repository_root = root + "plugins/visualizations/craviz/static/"

    hdadict = trans.security.encode_dict_ids( hda.to_dict() )
%>


<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>${hda.name | h} | ${visualization_name}</title>

        ${h.js( 'libs/jquery/jquery',
                'libs/jquery/jquery-ui')}

        <link rel="stylesheet" type="text/css" href="${repository_root}/css/datatables.css"/>
        <script type="text/javascript" src="${app_root}/lib/datatables.js"></script>


        ${h.js( 'libs/jquery/select2',
                'libs/bootstrap',
                'libs/underscore',
                'libs/backbone',
                'libs/d3',
                'libs/require')}
        ${h.css( 'base', 'jquery-ui/smoothness/jquery-ui' )}
        ${h.stylesheet_link( repository_root + "/css/style.css" )}
        ${h.stylesheet_link( repository_root + "/css/datatables.min.css" )}



    </head>
    <body>

        <div class="chart-header">
            <b>${default_title}</b>
        </div>

        <div id="container">
        </div>


        <script type="text/javascript">
            var app_root = '${app_root}';
            var repository_root = '${repository_root}';
            var Galaxy = Galaxy || parent.Galaxy || {
                root    : '${root}',
                emit    : {
                    debug: function() {}
                }
            };
            window.console = window.console || {
                log     : function(){},
                debug   : function(){},
                info    : function(){},
                warn    : function(){},
                error   : function(){},
                assert  : function(){}
            };
            require.config({
                baseUrl: Galaxy.root + "static/scripts/",
                paths: {
                    "plugin"        : "${app_root}",
                    "d3"            : "libs/d3",
                    "repository"    : "${repository_root}"
                },
                shim: {
                    "libs/underscore": { exports: "_" },
                    "libs/backbone": { exports: "Backbone" },
                    "d3": { exports: "d3" }
                }
            });

            // Go for api/histories/79966582feb6c081/contents/dataset_collections
            //console.log('${trans.security.encode_id( trans.history.id )}');

            $(function() {
                require( [ 'plugin/app' ], function( App ) {
                    var config = ${ h.dumps( config ) };

                    /*var app = new App({
                        dataset_names : ['Gene', 'Variant', 'Noncoding', 'Error'],
                        history_id : '${trans.security.encode_id( trans.history.id )}',
                        dataset_id  : config.dataset_id,
                        filename : '${hda.name | h}'});;*/
                    var app = new App({dataset_hid : '${hdadict["hid"]}',
                          peek : '${hdadict["peek"]}',
                          dataset_id : '${hdadict["id"]}',
                          history_id : '${hdadict["history_id"]}',
                          report_name : '${hdadict["name"]}'.replace('CRAVAT: ', '').replace(' Report',''),
                          report_names : {'Gene Level Annotation' : 'Gene',
                                            'Variant' : 'Variant', 
                                            'Non-coding Variant' :'Noncoding', 
                                            'Errors' : 'Error'}});
                    $('body').append(app.$el);
                    //$('body').append(app.footer);
                });
            });

            //var xhr = jQuery.getJSON('/api/datasets/' + 'e38f593eae81d119', {
            //var xhr = jQuery.getJSON("https://reqres.in/api/users?page=2", {

            /*var xhr2 = jQuery.getJSON('/api/datasets/' + '55504e7a2466a2e3', {
                data_type : 'raw_data',
                provider : 'column',
                limit: 1
            });

            xhr2.done( function (response) {
        */
            /*$(document).ready(function() {
                $('#example').DataTable( {
                    "ajax": {
                        "url": '/api/datasets/' + '55504e7a2466a2e3',
                        //"url" : 'templates/arrays.txt',
                        contentType: 'application/json; charset=utf-8',
                        dataType : 'json',
                        "data": {data_type : 'raw_data',
                            provider : 'column',
                            limit: 100000,
                            offset: 1}
                        /*success: function(data, textStatus, jqXHR) {
                            console.log('YOOODF');
                            console.log(data); //*** returns correct json data
                        }*/
                    /*},
                    'dataSrc' : 'data',
                    "bProcessing": true,
                    "bServerSide": false,
                    //"serverSide": true,
                    //"processing": true,
                } );
            } );
            //});

            /*$.ajax('/api/datasets/' + 'e38f593eae81d119', {
                data: {data_type : 'raw_data',
                        provider : 'column',
                        limit: 100},
                success: function(data, textStatus, jqXHR)
                {
                    console.log('YO');
                    console.log(data); //*** returns correct json data
                }
            });*/


        </script>
    </body>
</html>