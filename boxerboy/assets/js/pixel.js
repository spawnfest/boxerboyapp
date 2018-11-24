export var Pixel = (function() {
  let entity = {
    name: null,
    isPainting: false,
    colorPicker: null,
    table: null,
    cells: null
  };

  function clean(raw) {
    if (typeof raw == "undefined" || ! raw) {
      return null;
    } else {
      return raw;
    }
  }

  function alignColorPicker() {
    entity.colorPickerContainer.css("background-color", entity.colorPicker.val());
  }

  entity.refreshEditor = function() {
    const disabled = entity.name.val() == "";
    entity.save.removeClass("is-loading");
    entity.save.prop('disabled', disabled);
    entity.successModal.removeClass("is-active");
    entity.errorModal.removeClass("is-active");
  }

  entity.attemptSave = function()
  {
    entity.save.addClass("is-loading");
    entity.save.prop('disabled', true);
    $.ajax({
      url: '/api/build/terrain',
      type: "PUT",
      dataType: "json",
      data: entity.encode(),
      success: function (reply) {
        entity.successModal.addClass("is-active");
        setTimeout(entity.refreshEditor, 1000);
      },
      fail: function () {
        entity.errorModal.addClass("is-active");
      }
    });
  }

  entity.paintIf = function(cell) {
    if (entity.isPainting) {
      entity.paint(cell);
    }
  }

  entity.paint = function(cell, isStillPainting) {
    if (isStillPainting) {
      entity.isPainting = true;
    }

    const color = entity.colorPicker.val();
    cell.css('background-color', color);
    cell.attr("data-color", color);
  }

  entity.encode = function() {
    let encodedTable = [];
    let numRows = 0;
    let numColumns = 0;

    for (let i = 0, row; row = entity.table[0].rows[i]; i++) {
       numRows += 1;
       numColumns = 0;
       let encodedRow = []
       for (let j = 0, col; col = row.cells[j]; j++) {
          numColumns += 1;
          encodedRow.push(clean(col.dataset.color));
       }
       encodedTable.push(encodedRow);
    }
    return {
      name: entity.name.val(),
      rows: numRows,
      columns: numColumns,
      pixels: encodedTable,
    };
  }

  entity.run = function() {
    entity.table = $(".pixel-table");
    entity.cells = $(".pixel-column")
    entity.colorPickerContainer = $(".color-selector");
    entity.colorPicker = $(".color-selector > input");
    entity.name = $('[name="pixel-name"]');
    entity.save = $('[name="pixel-save"]');
    entity.errorModal = $(".pixel-editor .error-modal");
    entity.successModal = $(".pixel-editor .success-modal");

    entity.table.on("mousedown", "td", function() { entity.paint($(this), true) });
    entity.table.on("mouseup", "td", function() { entity.isPainting = false; });
    entity.table.on("click", "td", function() { entity.paint($(this), false); });
    entity.table.on("mouseover", "td", function() { entity.paintIf($(this)); });

    entity.colorPicker.on("change", null, function() {
      alignColorPicker();
    });
    alignColorPicker();

    entity.name.on("change", null, function() {
      entity.refreshEditor();
    });

    entity.name.on("keyup", null, function() {
      entity.refreshEditor();
    });

    entity.save.on("click", null, function() {
      entity.attemptSave();
    });

    entity.refreshEditor();
  }

  return entity;
})();
