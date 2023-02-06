;;; org-stealth.el --- A minor mode to clean org-mode.

;;; Commentary:
;;

(require 'org)

;;; Code:

(defgroup hide-region nil
  "Functions to hide region using an overlay with the invisible property.  The text is not affected."
  :prefix "hide-region-"
  :group 'convenience)

(defcustom hide-region-before-string "@["
  "String to mark the beginning of an invisible region. This string is
not really placed in the text, it is just shown in the overlay"
  :type 'string
  :group 'hide-region)

(defcustom hide-region-after-string "]@"
  "String to mark the beginning of an invisible region. This string is
not really placed in the text, it is just shown in the overlay"
  :type 'string
  :group 'hide-region)

(defcustom hide-region-propertize-markers t
  "If non-nil, add text properties to the region markers."
  :type 'boolean
  :group 'hide-region)

(defface hide-region-before-string-face
  '((t (:inherit region)))
  "Face for the before string.")

(defface hide-region-after-string-face
  '((t (:inherit region)))
  "Face for the after string.")

(defvar hide-region-overlays nil
  "Variable to store the regions we put an overlay on.")

;;;###autoload
(defun hide-region-hide ()
  "Hides a region by making an invisible overlay over it and save the
overlay on the hide-region-overlays \"ring\""
  (interactive)
  (let ((new-overlay (make-overlay (mark) (point))))
    (push new-overlay hide-region-overlays)
    (overlay-put new-overlay 'invisible t)
    (overlay-put new-overlay 'intangible t)
    (overlay-put new-overlay 'before-string
                 (if hide-region-propertize-markers
                     (propertize hide-region-before-string
                                 'font-lock-face 'hide-region-before-string-face)
                   hide-region-before-string))
    (overlay-put new-overlay 'after-string
                 (if hide-region-propertize-markers
                     (propertize hide-region-after-string
                                 'font-lock-face 'hide-region-after-string-face)
                   hide-region-after-string))))

;;;###autoload
(defun hide-region-unhide ()
  "Unhide a region at a time, starting with the last one hidden and
deleting the overlay from the hide-region-overlays \"ring\"."
  (interactive)
  (when (car hide-region-overlays)
    (delete-overlay (car hide-region-overlays))
    (setq hide-region-overlays (cdr hide-region-overlays))))

(defun org-tidy ()
  (interactive)
  (save-excursion
    (while (re-search-forward org-property-drawer-re nil t)
      (let* ((beg (1- (match-beginning 1)))
             (end (1+ (match-end 1))))
        (message "beg:%s end:%s" beg end)))))

(provide 'org-tidy)

;;; org-stealth.el ends here
