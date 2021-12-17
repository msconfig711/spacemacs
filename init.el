;;; init.el --- Spacemacs Initialization File -*- no-byte-compile: t -*-
;;
;; Copyright (c) 2012-2021 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Avoid garbage collection during startup.
;; see `SPC h . dotspacemacs-gc-cons' for more info
(setq byte-compile-warnings '(cl-functions))
(defconst emacs-start-time (current-time))
(setq gc-cons-threshold 402653184 gc-cons-percentage 0.6)
(load (concat (file-name-directory load-file-name)
              "core/core-versions.el")
      nil (not init-file-debug))
(load (concat (file-name-directory load-file-name)
              "core/core-load-paths.el")
      nil (not init-file-debug))
(load (concat spacemacs-core-directory "core-dumper.el")
      nil (not init-file-debug))

;; Remove compiled core files if they become stale or Emacs version has changed.
(load (concat spacemacs-core-directory "core-compilation.el")
      nil (not init-file-debug))
(load spacemacs--last-emacs-version-file t (not init-file-debug))
(when (or (not (string= spacemacs--last-emacs-version emacs-version))
          (spacemacs//dir-contains-stale-byte-compiled-files-p
           spacemacs-core-directory))
  (spacemacs//remove-byte-compiled-files-in-dir spacemacs-core-directory))
;; Update saved Emacs version.
(unless (string= spacemacs--last-emacs-version emacs-version)
  (spacemacs//update-last-emacs-version))

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  ;; Disable file-name-handlers for a speed boost during init
  (let ((file-name-handler-alist nil))
    (require 'core-spacemacs)
    (spacemacs/dump-restore-load-path)
    (configuration-layer/load-lock-file)
    (spacemacs/init)
    (configuration-layer/stable-elpa-init)
    (configuration-layer/load)
    (spacemacs-buffer/display-startup-note)
    (spacemacs/setup-startup-hook)
    (spacemacs/dump-eval-delayed-functions)
    (when (and dotspacemacs-enable-server (not (spacemacs-is-dumping-p)))
      (require 'server)
      (when dotspacemacs-server-socket-dir
        (setq server-socket-dir dotspacemacs-server-socket-dir))
      (unless (server-running-p)
        (message "Starting a server...")
        (server-start)))))
(require 'vline)
(set-face-background vline-face "#444444")
  ;;(with-eval-after-load 'org
    ;; 设置任务流程(这是我的配置)
    ;;可以在 () 中定义附加选项,包括:
    ;;
    ;;字符:该状态的快捷键
    ;;! : 切换到该状态时会自动添加时间戳
    ;;@ : 切换到该状态时要求输入文字说明
    ;;如果同时设定@和!,使用@/!
    (setq org-todo-keywords
          '((sequence "未开始(p!)" "进行中(t!)" "阻塞中(s!)" "|" "已完成(d!)" "已取消(a@/!)")))
    (setq org-log-done 'time)
    ;; 设置任务样式
    (setq org-todo-keyword-faces
          '(("未开始" .   (:foreground "red" :weight bold))
            ("阻塞中" .   (:foreground "red" :weight bold))
            ("进行中" .   (:foreground "orange" :weight bold))
            ("已完成" .   (:foreground "green" :weight bold))
            ("已取消" .   (:background "gray" :foreground "black"))
            ))
;;)))
    (setq org-agenda-custom-commands
          '(
            ("w" . "任务安排")
            ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
            ("wb" "重要且不紧急的任务" tags-todo "-weekly-monthly-daily+PRIORITY=\"B\"")
            ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
            ("W" "Weekly Review"
             ((stuck "") ;; review stuck projects as designated by org-stuck-projects
              (tags-todo "project")
              (tags-todo "daily")
              (tags-todo "weekly")
              (tags-todo "school")
              (tags-todo "code")
              (tags-todo "theory")
              ))
            ))

