;;; ob-gptel.el --- TODO Description -*- lexical-binding: t; -*-
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
;;; Commentary:
;;
;;  Description
;;
;;; Code:


(require 'ob)
(require 'gptel)

(defcustom org-babel-gptel-timeout 10
  "Timeout in seconds for a gptel request."
  :type 'integer
  :group 'org-babel)

(defcustom org-babel-gptel-default-model "gpt-3.5-turbo"
  "Default model to use for gptel requests."
  :type '(choice (const :tag "gpt-3.5-turbo" "gpt-3.5-turbo")
          (const :tag "gpt-4" "gpt-4")
          (const :tag "claude-v1" "claude-v1")
          (const :tag "claude-instant-v1" "claude-instant-v1")
          (string :tag "Other"))
  :group 'org-babel)

(defcustom org-babel-gptel-default-system-message ""
  "Default system message to use for gptel requests."
  :type 'string
  :group 'org-babel)

(defun org-babel-execute:gptel (body params)
  "Execute a block of Gptel code with org-babel.
This function is called by `org-babel-execute-src-block'."
  (let* ((model (or (cdr (assoc :model params))
                    org-babel-gptel-default-model))
         (system-message (or (cdr (assoc :system-message params))
                             org-babel-gptel-default-system-message))
         (timeout (or (cdr (assoc :timeout params))
                      org-babel-gptel-timeout))
         (response nil)
         (callback-func (lambda (resp info)
                          (setq response resp))))
    (gptel-request body
      :system system-message
      :model model
      :callback callback-func
      :timeout timeout)
    (or response "Error: gptel-request timed out.")))

(provide 'ob-gptel)
;;; ob-gptel.el ends here
