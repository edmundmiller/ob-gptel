;;; ob-gptel.el --- Org Babel functions for LLM evaluation via gptel -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Edmund Miller

;; Author: Edmund Miller <git@edmundmiller.dev>
;; Maintainer: Edmund Miller <git@edmundmiller.dev>
;; Created: August 29, 2024
;; Modified: August 29, 2024
;; Version: 0.0.1
;; Keywords: literate programming, reproducible research
;; Homepage: https://github.com/edmundmiller/ob-gptel
;; Package-Requires: ((emacs "25.1") (gptel "0.1"))

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; Copyright (C) 2024 Edmund Miller
;;
;; Author: Edmund Miller <git@edmundmiller.dev>
;; Maintainer: Edmund Miller <git@edmundmiller.dev>
;; Created: August 29, 2024
;; Modified: August 29, 2024
;; Version: 0.0.1
;; Keywords: TODO
;; Homepage: https://github.com/edmundmiller/ob-gptel
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Provides an org-babel interface for evaluating LLM prompts via the gptel package.

;;; Requirements:

;; - Emacs 25.1+
;; - gptel 0.1+

;;; Code:
(require 'ob)
(require 'ob-ref)
(require 'ob-comint)
(require 'ob-eval)
(require 'gptel)

;; optionally declare default header arguments for this language
(defvar org-babel-default-header-args:gptel
  '((:model . "gpt-3.5-turbo")
    (:system-message . "You are a helpful assistant."))
  "Default arguments for evaluating a gptel source block.")

(defcustom ob-gptel-default-model "gpt-3.5-turbo"
  "Default model to use when executing a gptel source block."
  :group 'org-babel
  :type 'string)

(defcustom ob-gptel-default-system-message "You are a helpful assistant."
  "Default system message to use when executing a gptel source block."
  :group 'org-babel
  :type 'string)

(defun org-babel-execute:gptel (body params)
  "Execute a block of GPTel code with org-babel."
  (let* ((processed-params (org-babel-process-params params))
         (model (or (cdr (assq :model processed-params))
                    ob-gptel-default-model))
         (system-message (or (cdr (assq :system-message processed-params))
                             ob-gptel-default-system-message)))
    (condition-case err
        (gptel-request
            body
          :system system-message
          :model model
          :callback (lambda (response _)
                      response))
      (error
       (format "GPTel request failed: %s" (error-message-string err))))))

(provide 'ob-gptel)
;;; ob-gptel.el ends here
