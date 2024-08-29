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

(require 'org)
(require 'ob)
(require 'gptel)

(defgroup org-babel-gptel nil
  "Org Babel support for GPTel."
  :group 'org-babel)

(defcustom org-babel-gptel-timeout 10
  "Timeout in seconds for a GPTel request."
  :type 'integer
  :group 'org-babel-gptel)

(defcustom org-babel-gptel-default-model "gpt-3.5-turbo"
  "Default model to use for GPTel requests."
  :type '(choice (const :tag "gpt-3.5-turbo" "gpt-3.5-turbo")
          (const :tag "gpt-4" "gpt-4")
          (const :tag "claude-v1" "claude-v1")
          (const :tag "claude-instant-v1" "claude-instant-v1")
          (string :tag "Other"))
  :group 'org-babel-gptel)

(defcustom org-babel-gptel-default-system-message ""
  "Default system message to use for GPTel requests."
  :type 'string
  :group 'org-babel-gptel)

(defun org-babel-execute:gptel (body params)
  "Execute a block of GPTel code with Org Babel.
BODY is the code to execute.
PARAMS are the header arguments specified in the code block."
  (let* ((model (or (alist-get :model params) org-babel-gptel-default-model))
         (system-message (or (alist-get :system-message params)
                             org-babel-gptel-default-system-message))
         (callback (lambda (response _)
                     (when (null response)
                       (error "GPTel request failed"))
                     response)))
    (gptel-request body
      :model model
      :system system-message
      :callback callback)))

(defvar org-babel-default-header-args:gptel
  '((:results . "output")
    (:gptel-default-mode . t))
  "Default arguments for evaluating a GPTel source block.")

(provide 'ob-gptel)
;;; ob-gptel.el ends here
