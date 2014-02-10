//$(function() {
//
//    var nowTemp = new Date();
//    var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
//
//    nowTemp.setDate(nowTemp.getDate()+1);
//
//    var secondPickerDate = nowTemp.getDate();
//    var secondPickerMonth = nowTemp.getMonth();
//    var secondPickerYear = nowTemp.getFullYear();
//
//    var checkin = $('#xdpd1').datetimepicker({
//        language: 'en',
//        pickTime: false,
//        format: 'dd/MM/yyyy',
//        startDate: new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 00, 00)
//    }).on('changeDate', function(ev) {
//            var eventTarget = jQuery(ev.target);
//            var picker = eventTarget.data('datetimepicker');
//            var tempDate = new Date(picker.getLocalDate());
//            tempDate.setDate(tempDate.getDate()+1);
//
//            if ($( '#xdpd2' ).length != 0){
//                $( '#xdpd2' ).datetimepicker( "destroy" );
//                $( '#xdpd2' ).children("input").val(new XDate(tempDate).toString('dd/MM/yyyy'));
//                tempDate.setDate(tempDate.getDate()+1);
//                var checkout = $('#xdpd2').datetimepicker({
//                    language: 'en',
//                    pickTime: false,
//                    format: 'dd/MM/yyyy',
//                    startDate: new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate(), 00, 00)//tempDate
//                }).on('changeDate', function(ev) {
//                        $(this).children("input").val(new XDate(ev.date).toString('dd/MM/yyyy'))
//                    }).data('datepicker');
//            }
//
//        }).data('datepicker');
//});