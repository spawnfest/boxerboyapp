export var Aggregate = (function() {
  let entity = {
    name: null,
    isPainting: false,
    aggregatePicker: null,
    selectedPixel: null,
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
      url: '/api/build/map',
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

    if (entity.selectedPixel) {
      cell.attr("data-name", entity.selectedPixel);
      cell.css("background-image", "url(/gen/terrain/" + entity.selectedPixel + ")");
    }
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
          encodedRow.push(clean(col.dataset.name));
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
    entity.table = $(".aggregate-table");
    entity.cells = $(".aggregate-column")
    entity.pixelPicker = $(".pixel-selector");
    entity.name = $('[name="aggregate-name"]');
    entity.save = $('[name="aggregate-save"]');
    entity.errorModal = $(".aggregator-editor .error-modal");
    entity.successModal = $(".aggregator-editor .success-modal");

    entity.table.on("mousedown", "td", function() { entity.paint($(this), true) });
    entity.table.on("mouseup", "td", function() { entity.isPainting = false; });
    entity.table.on("click", "td", function() { entity.paint($(this), false); });
    entity.table.on("mouseover", "td", function() { entity.paintIf($(this)); });

    entity.pixelPicker.on("click", ".pixel", function() {
      let all = entity.pixelPicker.children(".pixel");
      all.removeClass("pixel-on");
      all.addClass("pixel-off");

      let pixel = $(this);
      pixel.addClass("pixel-on");
      entity.selectedPixel = pixel.data("name");
    });

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
