export var Pixel = (function() {
  let entity = {
    name: null,
    isPainting: false,
    colorPicker: null,
    table: null,
    cells: null
  };

  /**
   * Encode the pixel information for saving in the pixeldb
   */
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
          encodedRow.push(clean(col.dataset.pixel));
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

  /**
   * Attempt a save, this will disable the button, run the
   * ajax call (to `/api/{pixelentity}`) and then report
   * the results based on `.success-modal` and `.error-modal`
   */
  entity.attemptSave = function()
  {
    entity.save.addClass("is-loading");
    entity.save.prop('disabled', true);
    $.ajax({
      url: `/api/${entity.save.data("pixelentity")}`,
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

  /**
   * Remove all "loading" spinners, any modals and determine
   * if `save` should be enabled.
   */
  entity.refreshEditor = function() {
    const disabled = entity.name.val() == "";
    entity.save.removeClass("is-loading");
    entity.save.prop('disabled', disabled);
    entity.successModal.removeClass("is-active");
    entity.errorModal.removeClass("is-active");
  }

  /**
   * If the paintbrush is "down" then paint it, if not
   * then ignore the event
   */
  entity.paintIf = function(cell) {
    if (entity.isPainting) {
      entity.paint(cell);
    }
  }

  /**
   * "Paint" the pixel (either a color or a saved pixel) on
   * the selected cell based on the type of picker
   * (which can be `color` or `picker`)
   */
  entity.paint = function(cell, isStillPainting) {
    if (isStillPainting) {
      entity.isPainting = true;
    }

    switch(entity.table.data("pixeltype")) {
      case "color":
        const color = entity.colorPicker.val();
        cell.css('background-color', color);
        cell.attr("data-pixel", color);
        break;
      case "pixel":
        if (entity.selectedPixel) {
          cell.attr("data-pixel", entity.selectedPixel);
          cell.css("background-image", `url("/gen/terrain/${entity.selectedPixel}")`);
        }
        break;
    }
  }

  /**
   * Register the "paint" events on the actula pixel table
   */
  function registerPixelTable() {
    entity.table = $(".pixel-table");
    entity.table.on("mousedown", "td", function() { entity.paint($(this), true) });
    entity.table.on("mouseup", "td", function() { entity.isPainting = false; });
    entity.table.on("click", "td", function() { entity.paint($(this), false); });
    entity.table.on("mouseover", "td", function() { entity.paintIf($(this)); });

  }

  /**
   * Register the color picker for "basic" pixels
   * that are based on a color code
   */
  function registerColorPicker() {
    entity.colorPickerContainer = $(".color-selector");
    entity.colorPicker = $(".color-selector > input");

    const alignPicker = function() {
      entity.colorPickerContainer.css("background-color", entity.colorPicker.val());
    }

    entity.colorPicker.on("change", null, function() {
      alignPicker();
    });
    alignPicker();
  }

  /**
   * Maps are an aggregate terrain pixels,
   * here we are registering to allow for the picking of an existing "pixel"
   * (for Maps, those would be terrains)
   */
  function registerPixelPicker() {
    entity.pixelPicker = $(".pixel-selector");
    entity.pixelPicker.on("click", ".pixel", function() {
      let all = entity.pixelPicker.children(".pixel");
      all.removeClass("pixel-on");
      all.addClass("pixel-off");

      let pixel = $(this);
      pixel.addClass("pixel-on");
      entity.selectedPixel = pixel.data("name");
    });
  }

  /**
   * Register the AJAX save button, as well as some
   * pre-save validation (i.e. must have a name
   * and then register the OK/Error modal popups on save
   */
  function registerSavePixel() {
    entity.name = $('[name="pixel-name"]');
    entity.save = $('[name="pixel-save"]');
    entity.errorModal = $(".error-modal");
    entity.successModal = $(".success-modal");

    entity.name.on("change", null, function() {
      entity.refreshEditor();
    });

    entity.name.on("keyup", null, function() {
      entity.refreshEditor();
    });

    entity.save.on("click", null, function() {
      entity.attemptSave();
    });
  }

  /**
   * Ensure that `undefined` or `""` are encoded
   * and cleaned as `null`.
   */
  function clean(raw) {
    if (typeof raw == "undefined" || ! raw) {
      return null;
    } else {
      return raw;
    }
  }

  /**
   * Register all the pixel editor events
   */
  entity.run = function() {
    registerPixelTable();
    registerColorPicker();
    registerPixelPicker();
    registerSavePixel();
    entity.refreshEditor();
  }

  return entity;
})();
