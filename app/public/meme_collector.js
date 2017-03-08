const filterInvalid = function(settings, data, dataIndex) {
  const table = $('.table').DataTable();
  const $row = table.rows(dataIndex).nodes().to$().first();
  const validMeme = !$row.attr('data-valid') || $row.data('valid');
  const validOnlyCheckBox = $('#valid_only');

  return validOnlyCheckBox.is(':checked') ? validMeme : true;
};

$.fn.dataTable.ext.search.push(filterInvalid);


const dataTableConfiguration = {
  "pageLength": 50
};

$(document).ready(function () {
  const table = $('.table').DataTable(dataTableConfiguration);

  $('#valid_only').change(() => table.draw());
});
