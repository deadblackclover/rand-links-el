;;; rand-links.el --- Random link generation utility

;; Author: DEADBLACKCLOVER <deadblackclover@protonmail.com>
;; Version: 0.1
;; URL: https://github.com/deadblackclover/rand-links-el
;; Package-Requires: ((emacs "26.3") (request "0.2.0"))

;; Copyright (c) 2021, DEADBLACKCLOVER. This file is
;; licensed under the GNU General Public License version 3 or later. See
;; the LICENSE file.

;;; Commentary:

;;; Code:
(defgroup rand-links nil
  "Random link generation utility"
  :group 'rand-links)

(defvar rand-links-char-pool "abcdefghijklmnopqrstuvwxyz0123456789"
  "Character pool.")

(defun rand-links-random-char ()
  "Getting a random character."
  (let* ((alnum rand-links-char-pool)
         (i (% (abs (random))
               (length alnum))))
    (substring alnum i (1+ i))))

(defun rand-links-buffer (data)
  "Create buffer and DATA recording."
  (switch-to-buffer (get-buffer-create "*rand-links*"))
  (mapc (lambda (item)
          (insert item)
          (insert "\n")) data)
  (org-mode)
  (goto-char (point-min)))

(defun rand-links-generate-string (acc length str)
  "A STR of a certain LENGTH is generated.
Since the function is recursive, the ACC is used."
  (if (< acc length)
      (rand-links-generate-string (1+ acc) length (concat str (rand-links-random-char))) str))

(defun rand-links-generate-link (length domain)
  "Generate random links of a specific LENGTH and ending in a specific DOMAIN."
  (concat (rand-links-generate-string 0 length "") domain))

(defun rand-links-generate-list (acc count domain length list-links)
  "Generate random links of a specific LENGTH and ending in a specific DOMAIN.
Since the function is recursive, the ACC is used.
The function also uses the COUNT of links.
The function returns a LIST-LINKS."
  (if (< acc count)
      (rand-links-generate-list (1+ acc) count domain length (append list-links (list
                                                                                 (rand-links-generate-link
                                                                                  length domain))))
    list-links))

(defun rand-links-generate-links (domain length count)
  "Generate random links of a specific LENGTH and ending in a specific DOMAIN.
The COUNT of links is also set."
  (rand-links-generate-list 0 count domain length nil))

(defun rand-links-set-char-pool (char-pool)
  "Set CHAR-POOL to character pool."
  (interactive "sCharacter pool:")
  (setq rand-links-char-pool char-pool)
  (message "Character pool successfully changed"))

(defun rand-links (domain length count)
  "Generate random links of a specific LENGTH and ending in a specific DOMAIN.
The function also uses the COUNT of links."
  (interactive "sTop-level domain:\nsLine length:\nsNumber of links:")
  (rand-links-buffer (rand-links-generate-links domain (string-to-number length)
                                                (string-to-number count))))
;;; rand-links.el ends here
